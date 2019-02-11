//
//  RiskDetailViewController.swift
//  MolueRiskPart
//
//  Created by MolueJames on 2018/11/7.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import UIKit
import MolueMediator
import MolueFoundation
import MolueUtilities

protocol RiskDetailPresentableListener: class {
    // 定义一些当前页面需要的业务逻辑, 比如网络请求.
    func jumpToBrowserController(with indexPath: IndexPath)
    
    func numberOfItems(in section: Int) -> Int?
    
    func queryPerilAttachment(with indexPath: IndexPath) -> String?
    
    func queryPerilSituation(with indexPath: IndexPath) -> String?
    
    func queryHiddenPeril() -> MLHiddenPerilItem?
}

final class RiskDetailViewController: MLBaseViewController  {
    //MARK: View Controller Properties
    var listener: RiskDetailPresentableListener?
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.register(xibWithCellClass: RiskDetailCollectionViewCell.self)
            collectionView.register(xibWithCellClass: AddProblemCollectionViewCell.self)
            collectionView.register(forKind:UICollectionView.elementKindSectionFooter, withNibClass: RiskDetailReusableHeaderView.self)
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
    
    //MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension RiskDetailViewController: MLUserInterfaceProtocol {
    func queryInformationWithNetwork() {
        
    }
    
    func updateUserInterfaceElements() {
        self.title = "隐患详情"
    }
}

extension RiskDetailViewController: RiskDetailPagePresentable {
    
}

extension RiskDetailViewController: RiskDetailViewControllable {
    
}

extension RiskDetailViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        do {
            let listener = try self.listener.unwrap()
            let count = listener.numberOfItems(in: section)
            return try count.unwrap()
        } catch {return 0}
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            return self.queryRiskDetailCell(with: collectionView, indexPath: indexPath)
        } else {
            return self.queryAddProblemCell(with: collectionView, indexPath: indexPath)
        }
    }
    
    func queryRiskDetailCell(with collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: RiskDetailCollectionViewCell.self, for: indexPath)
        do {
            let listener = try self.listener.unwrap()
            let image = listener.queryPerilAttachment(with: indexPath)
            try cell.refreshSubviews(with: image.unwrap())
        } catch {
            MolueLogger.UIModule.message(error)
        }
        return cell
    }
    
    func queryAddProblemCell(with collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: AddProblemCollectionViewCell.self, for: indexPath)
        do {
            let listener = try self.listener.unwrap()
            let situation = listener.queryPerilSituation(with: indexPath)
            try cell.refreshSubviews(with: situation.unwrap())
        } catch {
            MolueLogger.UIModule.message(error)
        }
        return cell
    }
}

extension RiskDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withClass: RiskDetailReusableHeaderView.self, for: indexPath)
        do {
            let listener = try self.listener.unwrap()
            let item = listener.queryHiddenPeril()
            try view.refreshSubviews(with: item.unwrap())
        } catch {
            MolueLogger.UIModule.message(error)
        }
        return view
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        do {
            let listener = try self.listener.unwrap()
            listener.jumpToBrowserController(with: indexPath)
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
}

extension RiskDetailViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let height: CGFloat = section == 0 ? 340 : 0
        let width: CGFloat = MLConfigure.ScreenWidth
        return CGSize(width: width, height: height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            let width: CGFloat = (MLConfigure.ScreenWidth - 56) / 3
            return CGSize(width: width, height: width)
        } else {
            return self.querySizeForSituation(with: indexPath)
        }
    }
    
    public func querySizeForSituation(with indexPath: IndexPath) -> CGSize {
        let width: CGFloat = MLConfigure.ScreenWidth
        do {
            let listener = try self.listener.unwrap()
            let item = try listener.queryPerilSituation(with: indexPath).unwrap()
            let height = item.estimateHeight(with: 15, width: width - 40)
            return CGSize(width: width, height: height + 25)
        } catch { return CGSize(width: width, height: 45) }
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
