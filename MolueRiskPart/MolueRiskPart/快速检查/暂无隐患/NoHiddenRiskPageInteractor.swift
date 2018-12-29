//
//  NoHiddenRiskPageInteractor.swift
//  MolueRiskPart
//
//  Created by MolueJames on 2018/11/23.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import MolueFoundation
import MolueMediator
import MolueCommon
import MolueUtilities
import RxSwift
import Gallery
import Photos
import MolueNetwork
import BoltsSwift

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
    
    private let disposeBag: DisposeBag = DisposeBag()
    
    lazy var currentAttachment: MLTaskAttachment? = {
        do {
            let listener = try self.listener.unwrap()
            return try listener.currentAttachment.unwrap()
        } catch {
            return MolueLogger.database.returnNil(error)
        }
    }()
    
    lazy var attachmentDetails: [MLAttachmentDetail]? = {
        do {
            let attachment = try self.currentAttachment.unwrap()
            return try attachment.attachments.unwrap()
        } catch {
            return MolueLogger.database.returnNil(error)
        }
    }()
    
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
    
    func queryAttactmentDetail(with index: Int) -> MLAttachmentDetail? {
        do {
            let details = try self.attachmentDetails.unwrap()
            return try details.item(at: index).unwrap()
        } catch {
            return MolueLogger.UIModule.allowNil(error)
        }
    }
    
    func uploadAttachmentPhotos(with attachments: [MLAttachmentDetail]) {
        let uploadTasks = self.createUploadTasks(with: attachments)
        Task.whenAll(uploadTasks).continueOnSuccessWith { [weak self] result in
            do {
                try self.unwrap().handleSuccessOperation()
            } catch { MolueLogger.network.message(error) }
        }.continueOnErrorWith { [weak self] (error) in
            do {
                try self.unwrap().handleFailureOperation()
            } catch { MolueLogger.network.message(error) }
        }
    }
    
    func createUploadTasks(with attachments: [MLAttachmentDetail]) -> [Task<Any?>]{
        var uploadTasks:[Task<Any?>] = [Task<Any?>]()
        attachments.forEach { (item, index) in
            do {
                let task = uploadPhotoTask(with: item, index: index)
                try uploadTasks.append(task.unwrap())
            } catch { MolueLogger.network.message(error) }
        }
        return uploadTasks
    }
    
    func handleSuccessOperation() {
        do {
            let presenter = try self.presenter.unwrap()
            presenter.showSuccessHUD(text: "上传图片成功")
        } catch { MolueLogger.UIModule.error(error) }
    }
    
    func handleFailureOperation() {
        do {
            let presenter = try self.presenter.unwrap()
            presenter.showFailureHUD(text: "上传图片失败,请重新上传")
        } catch { MolueLogger.UIModule.error(error) }
    }
    
    func uploadPhotoTask(with attachment: MLAttachmentDetail, index: Int) -> Task<Any?>? {
        do {
            let picture = try attachment.image.unwrap()
            let taskCompletionSource = TaskCompletionSource<Any?>()
            MolueFileService.uploadPicture(with: picture, success: { [weak self] result in
                taskCompletionSource.set(result: result)
                do {
                    try self.unwrap().update(with: attachment, result: result, index: index)
                } catch { MolueLogger.network.message(error) }
                
            }) { (error) in
                taskCompletionSource.set(error: error)
            }
            return taskCompletionSource.task
        } catch {
            return MolueLogger.UIModule.allowNil(error)
        }
    }
    
    func update(with attachment:MLAttachmentDetail, result: Any?, index: Int) {
        attachment.updateAttachment(with: result)
        self.attachmentDetails?[index] = attachment
    }
}

extension NoHiddenRiskPageInteractor: NoHiddenRiskPresentableListener {
    func queryCurrentImageCount() -> Int? {
        do {
            let details = try self.attachmentDetails.unwrap()
            let imageCount: Int = details.count
            return imageCount > maxImageCount ? maxImageCount : imageCount + 1
        } catch {
            return MolueLogger.UIModule.allowNil(error)
        }
    }
    
    func queryNavigationTitle() -> String {
        do {
            let current = try self.currentAttachment.unwrap()
            return try current.content.unwrap()
        } catch { return "检查详情" }
    }
    
    func querySubmitCommand() -> PublishSubject<String> {
        let submitCommand = PublishSubject<String>()
        submitCommand.subscribe(onNext: { [unowned self] (remark) in
            self.updateCurrentAttachment(with: remark)
        }).disposed(by: self.disposeBag)
        return submitCommand
    }
    
    func queryCurrentAttachmentRemark() -> String {
        do {
            let attachment = try self.currentAttachment.unwrap()
            return try attachment.remark.unwrap()
        } catch { return "" }
    }
    
    func didSelectItemAt(indexPath: IndexPath) {
        let count = self.attachmentDetails?.count ?? 0
        if (indexPath.row < count) {
            self.jumpToBrowserController(with: indexPath.row)
        } else {
            self.jumpToTakePhotoController()
        }
    }
    
    func numberOfItemsInSection() -> Int? {
        do {
            let details = try self.attachmentDetails.unwrap()
            let imageCount: Int = details.count
            return imageCount > maxImageCount ? maxImageCount : imageCount + 1
        } catch {
            return MolueLogger.UIModule.allowNil(error)
        }
    }
    
    func queryAttactment(with indexPath: IndexPath) -> MLAttachmentDetail? {
        do {
            let details = try self.attachmentDetails.unwrap()
            return try details.item(at: indexPath.row).unwrap()
        } catch {
            return MolueLogger.UIModule.allowNil(error)
        }
    }
    
    func updateCurrentAttachment(with remark: String) {
        do {
            self.currentAttachment?.remark = remark
            let listener = try self.listener.unwrap()
            let updatedAttachment = try self.currentAttachment.unwrap()
            listener.updateCurrentAttachment(with: updatedAttachment)
            let router = try self.viewRouter.unwrap()
            router.popToPreviewController()
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
