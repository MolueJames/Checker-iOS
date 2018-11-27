//
//  NoHiddenRiskPageInteractor.swift
//  MolueRiskPart
//
//  Created by MolueJames on 2018/11/23.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import MolueUtilities
import MolueFoundation
import MolueMediator
import MolueCommon
import Gallery
import Photos

protocol NoHiddenRiskViewableRouting: class {
    // 定义一些页面跳转的方法, 比如Push, Presenter等.
    func pushToTakePhotoController(with limit: Int)
    func pushToPhotoBrowser(with photos: [SKPhoto], controller: UIViewController)
    func pushToPhotoBrowser(with photos: [SKPhoto], index: Int)
    func popToPreviewController()
}

protocol NoHiddenRiskPagePresentable: MolueInteractorPresentable, MLControllerHUDProtocol {
    var listener: NoHiddenRiskPresentableListener? { get set }
    // 定义一些页面需要的方法, 比如刷新页面的显示内容等.
    func reloadCollectionViewData()
}

final class NoHiddenRiskPageInteractor: MoluePresenterInteractable {
    internal var maxImageCount: Int = 9
    
    internal var photoImages: [UIImage]?

    weak var presenter: NoHiddenRiskPagePresentable?
    
    var viewRouter: NoHiddenRiskViewableRouting?
    
    weak var listener: NoHiddenRiskInteractListener?
    
    private weak var photoController: GalleryController?
    
    required init(presenter: NoHiddenRiskPagePresentable) {
        self.presenter = presenter
        presenter.listener = self
    }
}

extension NoHiddenRiskPageInteractor: NoHiddenRiskRouterInteractable {
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        controller.dismiss(animated: true, completion: nil)
        Image.resolve(images: images) { [weak self] resolvedImages in
            do {
                let images = resolvedImages.compactMap({$0})
                let strongSelf = try self.unwrap()
                if strongSelf.photoImages == nil {
                    strongSelf.photoImages = images
                } else {
                    strongSelf.photoImages?.append(contentsOf: images)
                }
                let presenter = try strongSelf.presenter.unwrap()
                presenter.reloadCollectionViewData()
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
                let router = try strongSelf.viewRouter.unwrap()
                let photoImages:[SKPhoto] = images.map {
                    SKPhoto.photoWithImage($0)
                }
                router.pushToPhotoBrowser(with: photoImages, controller: controller)
            } catch {
                MolueLogger.UIModule.error(error)
            }
        }
        self.photoController = controller
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func removePhoto(_ browser: SKPhotoBrowser, index: Int, reload: @escaping (() -> Void)) {
        func removePhoto(from controller: GalleryController?) {
            do {
                let photoController = try controller.unwrap()
                var images = photoController.cart.images
                let image = images.remove(at: index)
                photoController.cart.remove(image)
                photoController.cart.reload(images)
            } catch {
                MolueLogger.UIModule.message(error)
            }
        }
        defer { reload() }
        do {
            self.photoImages?.remove(at: index)
            let presenter = try self.presenter.unwrap()
            presenter.reloadCollectionViewData()
        } catch {
            MolueLogger.UIModule.message(error)
        }
        removePhoto(from: self.photoController)
    }
}

extension NoHiddenRiskPageInteractor: NoHiddenRiskPresentableListener {
    func updateNoHiddenRisk(with text: String) {
        do {
            let taskModel: TaskSuccessModel = TaskSuccessModel()
            taskModel.images = self.photoImages
            taskModel.detail = text
            let listener = try self.listener.unwrap()
            listener.updateNoHiddenRiskModel(with: taskModel)
            self.doUpdateTaskInfoModelPresenter()
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    func doUpdateTaskInfoModelPresenter() {
        do {
            let presenter = try self.presenter.unwrap()
            presenter.showSuccessHUD(text: "任务检查完成")
            Async.main(after: 1.5) { [weak self] in
                do {
                    let router = try self.unwrap().viewRouter.unwrap()
                    router.popToPreviewController()
                } catch {
                    MolueLogger.UIModule.message(error)
                }
            }
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    func jumpToBrowserController(with index: Int) {
        do {
            let router = try self.viewRouter.unwrap()
            let images = try self.photoImages.unwrap()
            let photoImages:[SKPhoto] = images.map {
                SKPhoto.photoWithImage($0)
            }
            router.pushToPhotoBrowser(with: photoImages, index: index)
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    func jumpToTakePhotoController() {
        do {
            let viewRouter = try self.viewRouter.unwrap()
            let current = self.photoImages?.count ?? 0
            let limit = self.maxImageCount - current
            viewRouter.pushToTakePhotoController(with: limit)
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
}
