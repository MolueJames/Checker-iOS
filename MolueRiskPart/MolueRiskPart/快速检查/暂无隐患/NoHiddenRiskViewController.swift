//
//  NoHiddenRiskViewController.swift
//  MolueRiskPart
//
//  Created by MolueJames on 2018/11/23.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import UIKit
import RxSwift
import MolueFoundation
import MolueUtilities
import MolueMediator
import MolueCommon

protocol NoHiddenRiskPresentableListener: class {
    // 定义一些当前页面需要的业务逻辑, 比如网络请求.
    
    func numberOfItemsInSection() -> Int?
    
    func queryAttactment(with indexPath: IndexPath) -> MLAttachmentDetail?
    
    func jumpToTakePhotoController()
    
    func queryCurrentAttachmentRemark() -> String
    
    func jumpToBrowserController(with index: Int)
    
    func didSelectItemAt(indexPath: IndexPath)
    
    func querySubmitCommand() -> PublishSubject<String>
    
    func queryNavigationTitle() -> String
    
    func queryCurrentImageCount() -> Int?
}

final class NoHiddenRiskViewController: MLBaseViewController {
    //MARK: View Controller Properties
    var listener: NoHiddenRiskPresentableListener?
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.register(forKind:UICollectionView.elementKindSectionFooter, withNibClass: NoHiddenRiskReusableFooterView.self)
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
            flowLayout.footerReferenceSize = CGSize(width: MLConfigure.ScreenWidth, height: 195)
        }
    }
    
    func estimateFrameForText(text: String) -> CGRect {
        let style = NSMutableParagraphStyle()
        style.lineBreakMode = .byWordWrapping
        let size = CGSize(width: MLConfigure.ScreenWidth - 40, height: CGFloat.infinity)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let textFontAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15), NSAttributedString.Key.paragraphStyle: style]
        return NSString(string: text).boundingRect(with: size, options: options, attributes:textFontAttributes, context: nil)
    }
    
    //MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension NoHiddenRiskViewController: MLUserInterfaceProtocol {
    func queryInformationWithNetwork() {
        
    }
    
    func updateUserInterfaceElements() {
        do {
            let listener = try self.listener.unwrap()
            self.title = listener.queryNavigationTitle()
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
}

extension NoHiddenRiskViewController: NoHiddenRiskPagePresentable {
    func reloadCollectionViewData() {
        self.collectionView.reloadData()
    }
}

extension NoHiddenRiskViewController: NoHiddenRiskViewControllable {
    
}

extension NoHiddenRiskViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withClass: NoHiddenRiskReusableFooterView.self, for: indexPath)
        do {
            let listener = try self.listener.unwrap()
            let remark = listener.queryCurrentAttachmentRemark()
            view.refreshSubviews(with: remark)
            view.submitInfoCommand = listener.querySubmitCommand()
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

extension NoHiddenRiskViewController: UICollectionViewDataSource {
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
        let cell = collectionView.dequeueReusableCell(withClass: EditRiskInfoCollectionViewCell.self, for: indexPath)
        do {
            let listener = try self.listener.unwrap()
            let item = listener.queryAttactment(with: indexPath)
            try cell.refreshSubView(with: item.unwrap())
        } catch { MolueLogger.UIModule.message(error) }
        return cell
    }
}
