//
//  NoHiddenRiskViewController.swift
//  MolueRiskPart
//
//  Created by MolueJames on 2018/11/23.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import UIKit
import MolueFoundation
import MolueUtilities
import MolueCommon

protocol NoHiddenRiskPresentableListener: class {
    // 定义一些当前页面需要的业务逻辑, 比如网络请求.
    var maxImageCount: Int {get}
    
    var photoImages: [UIImage]? {get}
    
    func jumpToTakePhotoController()
    
    func jumpToBrowserController(with index: Int)
}

final class NoHiddenRiskViewController: MLBaseViewController  {
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
//            let size = self.estimateFrameForText(text: text)
            
            flowLayout.footerReferenceSize = CGSize(width: MLConfigure.ScreenWidth, height: 230)
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
        self.title = "检查详情"
        do {
            let listener = try self.listener.unwrap()
            listener.jumpToTakePhotoController()
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
        return view
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        do {
            let listener = try self.listener.unwrap()
            let imagesCount = listener.photoImages?.count ?? 0
            if (indexPath.row >= imagesCount) {
                listener.jumpToTakePhotoController()
            } else {
                listener.jumpToBrowserController(with: indexPath.row)
            }
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
}

extension NoHiddenRiskViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        do {
            let listener = try self.listener.unwrap()
            let images = try listener.photoImages.unwrap()
            let imageCount = listener.maxImageCount
            return images.count >= imageCount ? imageCount : images.count + 1
        } catch { return 1 }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imagesCount = self.listener?.photoImages?.count ?? 0
        if indexPath.row < imagesCount {
            let cell = collectionView.dequeueReusableCell(withClass: EditRiskInfoCollectionViewCell.self, for: indexPath)
            let image = self.listener?.photoImages?[indexPath.row]
            cell.reloadSubView(with: image!)
            return cell
        }
        return collectionView.dequeueReusableCell(withClass: InsertPhotosCollectionViewCell.self, for: indexPath)
    }
    
    
}
