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
    func jumpToBrowserController(with index: Int)
    
    func numberOfItemsInSection() -> Int?
    
    func queryPerielImage(with indexPath: IndexPath) -> String?
    
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
            collectionView.register(forKind:UICollectionView.elementKindSectionFooter, withNibClass: RiskDetailReusableHeaderView.self)
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        do {
            let listener = try self.listener.unwrap()
            let count = listener.numberOfItemsInSection()
            return try count.unwrap()
        } catch {return 0}
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: RiskDetailCollectionViewCell.self, for: indexPath)
        do {
            let listener = try self.listener.unwrap()
            let image = listener.queryPerielImage(with: indexPath)
            try cell.refreshSubviews(with: image.unwrap())
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
            listener.jumpToBrowserController(with: indexPath.row)
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
}

extension RiskDetailViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        do {
            let listener = try self.listener.unwrap()
            let model = listener.queryHiddenPeril()
            let memo = try model.unwrap().perilMemo.data()
            let width: CGFloat = MLConfigure.ScreenWidth - 40
            let height = memo.estimateHeight(with: 14, width: width, lineSpacing: 8)
            return CGSize(width: MLConfigure.ScreenWidth, height: height + 360)
        } catch { return CGSize(width: MLConfigure.ScreenWidth, height: 0)}
    }
}
