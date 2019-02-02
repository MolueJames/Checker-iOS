//
//  EditRiskInfoViewController.swift
//  MolueRiskPart
//
//  Created by MolueJames on 2018/11/17.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import UIKit
import RxSwift
import MolueCommon
import MolueMediator
import MolueUtilities
import MolueFoundation

protocol EditRiskInfoPresentableListener: class {
    // 定义一些当前页面需要的业务逻辑, 比如网络请求.
    func numberOfItems(in section: Int) -> Int?
    
    func queryAttactment(with indexPath: IndexPath) -> MLAttachmentDetail?
    
    func submitHiddenPerilItem(with hiddenPeril: MLHiddenPerilItem)
    
    func queryFindProblem(with indexPath: IndexPath) -> String?
    
    func queryInsertCommand() -> PublishSubject<Void>
    
    func submitHiddenPerilItem(with error: Error)
    
    func queryDetailRisk() -> MLRiskPointDetail?
    
    func didSelectItemAt(indexPath: IndexPath)
    
    func queryCurrentImageCount() -> Int?
    
    func jumpToQuickCheckController()
    
    func jumpToTakePhotoController()
}

final class EditRiskInfoViewController: MLBaseViewController  {
    //MARK: View Controller Properties
    var listener: EditRiskInfoPresentableListener?
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.register(forKind:UICollectionView.elementKindSectionFooter, withNibClass:
                EditRiskInfoResuableFooterView.self)
            collectionView.register(forKind:UICollectionView.elementKindSectionFooter, withNibClass: AddProblemResuableFooterView.self)
            collectionView.register(xibWithCellClass: EditRiskInfoCollectionViewCell.self)
            collectionView.register(xibWithCellClass: InsertPhotosCollectionViewCell.self)
            collectionView.register(xibWithCellClass: AddProblemCollectionViewCell.self)
            self.flowLayout = UICollectionViewFlowLayout()
            collectionView.collectionViewLayout = self.flowLayout
        }
    }

    private var flowLayout: UICollectionViewFlowLayout! {
        didSet {
            flowLayout.scrollDirection = .vertical
            flowLayout.minimumInteritemSpacing = 10
        }
    }
    
    private var footerView: EditRiskInfoResuableFooterView?
    
    lazy var rightBarItem: UIBarButtonItem = {
        let selector = #selector(rightBarItemClicked)
        return UIBarButtonItem(title: "提交", style: .plain, target: self, action: selector)
    }()
    
    @IBAction func rightBarItemClicked(sender: UIBarButtonItem) {
        guard let listener = self.listener else { return }
        do {
            let footerView = try self.footerView.unwrap()
            let perilItem = try footerView.queryHiddenPeril()
            listener.submitHiddenPerilItem(with: perilItem)
        } catch  {
            if let error = error as? EditRiskInfoRrror {
                listener.submitHiddenPerilItem(with: error)
            }
            MolueLogger.UIModule.message(error)
        }
    }
    //MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "隐患详情"
    }
}

extension EditRiskInfoViewController: MLUserInterfaceProtocol {
    func queryInformationWithNetwork() {
        
    }
    
    func updateUserInterfaceElements() {
        self.navigationItem.rightBarButtonItem = self.rightBarItem
        do {
            let listener = try self.listener.unwrap()
            listener.jumpToQuickCheckController()
        } catch { MolueLogger.UIModule.error(error) }
    }
}

extension EditRiskInfoViewController: EditRiskInfoPagePresentable {
    func reloadCollectionViewCell() {
        self.collectionView.reloadData()
    }
}

extension EditRiskInfoViewController: EditRiskInfoViewControllable {
    
}

extension EditRiskInfoViewController: UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let kind: String = UICollectionView.elementKindSectionFooter
        if indexPath.section == 0 {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withClass: EditRiskInfoResuableFooterView.self, for: indexPath)
            do {
                let listener = try self.listener.unwrap()
                let detailRisk = listener.queryDetailRisk()
                try view.refreshSubviews(with: detailRisk.unwrap())
            } catch { MolueLogger.UIModule.message(error) }
            self.footerView = view
            return view
        } else {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withClass: AddProblemResuableFooterView.self, for: indexPath)
            do {
                let listener = try self.listener.unwrap()
                view.submitCommand = listener.queryInsertCommand()
            } catch { MolueLogger.UIModule.message(error)}
            return view
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        do {
            let listener = try self.listener.unwrap()
            listener.didSelectItemAt(indexPath: indexPath)
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
}

extension EditRiskInfoViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        do {
            let listener = try self.listener.unwrap()
            let count = listener.numberOfItems(in: section)
            return try count.unwrap()
        } catch { return 1 }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            return self.queryPhotosCollectionCell(with: collectionView, indexPath: indexPath)
        } else {
            return self.queryProblemCollectionCell(with: collectionView, indexPath: indexPath)
        }
    }
    
    func queryProblemCollectionCell(with collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: AddProblemCollectionViewCell.self, for: indexPath)
        do {
            let listener = try self.listener.unwrap()
            let item = listener.queryFindProblem(with: indexPath)
            try cell.refreshSubviews(with: item.unwrap())
        } catch { MolueLogger.UIModule.message(error) }
        return cell
    }
    
    func queryPhotosCollectionCell(with collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row < self.listener?.queryCurrentImageCount() ?? 0 {
            let cell = collectionView.dequeueReusableCell(withClass: EditRiskInfoCollectionViewCell.self, for: indexPath)
            do {
                let listener = try self.listener.unwrap()
                let item = listener.queryAttactment(with: indexPath)
                try cell.refreshSubviews(with: item.unwrap())
            } catch { MolueLogger.UIModule.message(error) }
            return cell
        }
        return collectionView.dequeueReusableCell(withClass: InsertPhotosCollectionViewCell.self, for: indexPath)
    }
}

extension EditRiskInfoViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            let width = (MLConfigure.ScreenWidth - 56) / 3
            return CGSize(width: width, height: width)
        } else {
            return self.querySizeForSituation(with: indexPath)
        }
    }
    
    public func querySizeForSituation(with indexPath: IndexPath) -> CGSize {
        let width: CGFloat = MLConfigure.ScreenWidth
        do {
            let listener = try self.listener.unwrap()
            let item = try listener.queryFindProblem(with: indexPath).unwrap()
            let height = item.estimateHeight(with: 15, width: width - 40)
            return CGSize(width: width, height: height + 25)
        } catch { return CGSize(width: width, height: 45) }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let height: CGFloat = section == 0 ? 170 : 45
        let width: CGFloat = MLConfigure.ScreenWidth
        return CGSize(width: width, height: height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        } else {
            return UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return section == 0 ? 10 : 0
    }
}
