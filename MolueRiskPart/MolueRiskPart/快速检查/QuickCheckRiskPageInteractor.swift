//
//  QuickCheckRiskPageInteractor.swift
//  MolueRiskPart
//
//  Created by MolueJames on 2018/11/12.
//  Copyright © 2018 MolueTech. All rights reserved.
//
import MolueUtilities
import MolueMediator
import MolueCommon
import Gallery

protocol QuickCheckRiskViewableRouting: class {
    // 定义一些页面跳转的方法, 比如Push, Presenter等.
    func pushToTakePhotoController()
    func pushToScanQRCodeController()
    func pushToPhotoBrowser(with photos: [SKPhoto], controller: UIViewController)
    func pushToEditRiskController()
    func pushToDailyCheckController()
}

protocol QuickCheckRiskPagePresentable: MolueInteractorPresentable {
    var listener: QuickCheckRiskPresentableListener? { get set }
    // 定义一些页面需要的方法, 比如刷新页面的显示内容等.
}

final class QuickCheckRiskPageInteractor: MoluePresenterInteractable {
    
    weak var presenter: QuickCheckRiskPagePresentable?
    
    var viewRouter: QuickCheckRiskViewableRouting?
    
    weak var listener: QuickCheckRiskInteractListener?
    
    var photoImages: [UIImage]?
    
    required init(presenter: QuickCheckRiskPagePresentable) {
        self.presenter = presenter
        presenter.listener = self
    }
}

extension QuickCheckRiskPageInteractor: QuickCheckRiskRouterInteractable {
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        controller.dismiss(animated: true, completion: nil)
        Image.resolve(images: images) { [weak self] resolvedImages in
            do {
                let images = resolvedImages.compactMap({$0})
                let strongSelf = try self.unwrap()
                strongSelf.photoImages = images
                let router = try strongSelf.viewRouter.unwrap()
                router.pushToEditRiskController()
            } catch {
                MolueLogger.UIModule.error(error)
            }
        }
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        Image.resolve(images: images) { [weak self] resolvedImages in
            guard resolvedImages.count > 0 else {return}
            do {
                let images = resolvedImages.compactMap({$0})
                let strongSelf = try self.unwrap()
                strongSelf.photoImages = images
                let router = try strongSelf.viewRouter.unwrap()
                let photoImages:[SKPhoto] = images.map {
                    SKPhoto.photoWithImage($0)
                }
                router.pushToPhotoBrowser(with: photoImages, controller: controller)
            } catch {
                MolueLogger.UIModule.error(error)
            }
        }
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func didScannedQRCode(with QRCode: String, controller: SWQRCodeViewController) {
        do {
            let navigator = try controller.navigationController.unwrap()
            navigator.popViewController(animated: false)
            let viewRouter = try self.viewRouter.unwrap()
            viewRouter.pushToDailyCheckController()
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
}

extension QuickCheckRiskPageInteractor: QuickCheckRiskPresentableListener {
    func jumpToScanQRCodeController() {
        do {
            let viewRouter = try self.viewRouter.unwrap()
            viewRouter.pushToScanQRCodeController()
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    func jumpToTakePhotoController() {
        do {
            let viewRouter = try self.viewRouter.unwrap()
            viewRouter.pushToTakePhotoController()
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
}
