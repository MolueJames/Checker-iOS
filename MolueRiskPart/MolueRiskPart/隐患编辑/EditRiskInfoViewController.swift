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
    func numberOfItemsInSection() -> Int?
    
    func queryAttactment(with indexPath: IndexPath) -> MLAttachmentDetail?
    
    func jumpToTakePhotoController()
    
    func jumpToQuickCheckController()
    
    func queryCurrentImageCount() -> Int?
    
    func didSelectItemAt(indexPath: IndexPath)
    
    var detailRisk: MLRiskPointDetail? { get }
    
    var attachment: MLTaskAttachment? { get }
    
    func querySubmitCommand() -> PublishSubject<PotentialRiskModel>
}

final class EditRiskInfoViewController: MLBaseViewController  {
    //MARK: View Controller Properties
    var listener: EditRiskInfoPresentableListener?
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.register(forKind:UICollectionView.elementKindSectionFooter, withNibClass: EditRiskInfoResuableFooterView.self)
            collectionView.register(xibWithCellClass: EditRiskInfoCollectionViewCell.self)
            collectionView.register(xibWithCellClass: InsertPhotosCollectionViewCell.self)
            self.flowLayout = UICollectionViewFlowLayout()
            collectionView.collectionViewLayout = self.flowLayout
        }
    }

    private var flowLayout: UICollectionViewFlowLayout! {
        didSet {
            flowLayout.scrollDirection = .vertical
            flowLayout.minimumInteritemSpacing = 10
            flowLayout.minimumInteritemSpacing = 10
            flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
            let width: CGFloat = (MLConfigure.ScreenWidth - 56) / 3
            flowLayout.itemSize = CGSize(width: width, height: width)
            flowLayout.footerReferenceSize = CGSize(width: MLConfigure.ScreenWidth, height: 375)
        }
    }
    //MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
}

extension EditRiskInfoViewController: MLUserInterfaceProtocol {
    func queryInformationWithNetwork() {
        
    }
    
    func updateUserInterfaceElements() {
        self.title = "隐患详情"
        do {
            let listener = try self.listener.unwrap()
            listener.jumpToQuickCheckController()
        } catch { MolueLogger.UIModule.error(error) }
    }
}

extension EditRiskInfoViewController: EditRiskInfoPagePresentable {
    func reloadCollectionViewData() {
        self.collectionView.reloadData()
    }
}

extension EditRiskInfoViewController: EditRiskInfoViewControllable {
    
}

extension EditRiskInfoViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let kind: String = UICollectionView.elementKindSectionFooter
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withClass: EditRiskInfoResuableFooterView.self, for: indexPath)
        do {
            let listener = try self.listener.unwrap()
            let attachment = try listener.attachment.unwrap()
            let detailRisk = try listener.detailRisk.unwrap()
            view.refreshSubviews(with: attachment, riskUnit: detailRisk)
//            view.submitInfoCommand = listener.querySubmitCommand()
        } catch { MolueLogger.UIModule.message(error) }
        return view
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
            return try listener.numberOfItemsInSection().unwrap()
        } catch { return 1 }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row < self.listener?.queryCurrentImageCount() ?? 0 {
            return self.queryCollectionCell(with: collectionView, indexPath: indexPath)
        }
        return collectionView.dequeueReusableCell(withClass: InsertPhotosCollectionViewCell.self, for: indexPath)
    }
    
    func queryCollectionCell(with collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: EditRiskInfoCollectionViewCell.self.self, for: indexPath)
        do {
            let listener = try self.listener.unwrap()
            let item = listener.queryAttactment(with: indexPath)
            try cell.refreshSubviews(with: item.unwrap())
        } catch { MolueLogger.UIModule.message(error) }
        return cell
    }
}
