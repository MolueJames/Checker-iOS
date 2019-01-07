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
    var maxImageCount: Int {get}
    
    var photoImages: [UIImage]? {get}
    
    func jumpToTakePhotoController()
    
    func jumpToBrowserController(with index: Int)
    
    func updateEditRiskInfo(with model: PotentialRiskModel)
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
//        do {
//            let listener = try self.listener.unwrap()
//            listener.jumpToTakePhotoController()
//        } catch {
//            MolueLogger.UIModule.error(error)
//        }
    }
}

extension EditRiskInfoViewController: MLUserInterfaceProtocol {
    func queryInformationWithNetwork() {
        
    }
    
    func updateUserInterfaceElements() {
        self.title = "隐患详情"
        
    }
}

extension EditRiskInfoViewController: EditRiskInfoPagePresentable {
    func removeSelectedPhoto(with index: Int) {
//        let indexPath = IndexPath(item: index,  : 0)
//        self.collectionView.deleteItems(at: [indexPath])
    }
    
    func reloadCollectionViewData() {
        self.collectionView.reloadData()
    }
}

extension EditRiskInfoViewController: EditRiskInfoViewControllable {
    
}

extension EditRiskInfoViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withClass: EditRiskInfoResuableFooterView.self, for: indexPath)
        view.refreshSubview(with: nil)
        view.submitInfoCommand?.subscribe(onNext: { [unowned self] (model) in
            self.doSuccessSubmitInfo(with: model)
        }, onError: { [unowned self] (error) in
            self.showFailureHUD(text: error.localizedDescription)
        }).disposed(by: disposeBag)
        return view
    }
    
    func doSuccessSubmitInfo(with model: PotentialRiskModel) {
        do {
            let listener = try self.listener.unwrap()
            listener.updateEditRiskInfo(with: model)
        } catch {
            MolueLogger.UIModule.error(error)
        }
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

extension EditRiskInfoViewController: UICollectionViewDataSource {
    
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
            cell.refreshSubview(with: image!)
            return cell
        }
        return collectionView.dequeueReusableCell(withClass: InsertPhotosCollectionViewCell.self, for: indexPath)
    }
}
