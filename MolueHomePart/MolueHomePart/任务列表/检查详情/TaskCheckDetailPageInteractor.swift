//
//  TaskCheckDetailPageInteractor.swift
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

protocol TaskCheckDetailViewableRouting: class {
    // 定义一些页面跳转的方法, 比如Push, Presenter等.
    func pushToTakePhotoController(with limit: Int)
    func pushToPhotoBrowser(with photos: [SKPhoto], controller: UIViewController)
    func pushToPhotoBrowser(with photos: [SKPhoto], index: Int)
    func popToPreviewController()
}

protocol TaskCheckDetailPagePresentable: MolueInteractorPresentable, MLControllerHUDProtocol, MolueActivityDelegate {
    var listener: TaskCheckDetailPresentableListener? { get set }
    // 定义一些页面需要的方法, 比如刷新页面的显示内容等.
    func reloadCollectionViewData()
}

final class TaskCheckDetailPageInteractor: MoluePresenterInteractable {
    internal var maxImageCount: Int = 3

    weak var presenter: TaskCheckDetailPagePresentable?
    
    var viewRouter: TaskCheckDetailViewableRouting?
    
    weak var listener: TaskCheckDetailInteractListener?
    
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
            return MolueLogger.database.allowNil(error)
        }
    }()
    
    required init(presenter: TaskCheckDetailPagePresentable) {
        self.presenter = presenter
        presenter.listener = self
    }
}

extension TaskCheckDetailPageInteractor: TaskCheckDetailRouterInteractable {
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        controller.dismiss(animated: true, completion: nil)
        Image.resolve(images: images) { [weak self] images in
            do {
                let attachments: [MLAttachmentDetail] = images.compactMap({ image in
                    return MLAttachmentDetail(image)
                })
                try self.unwrap().updateAttacments(with: attachments)
                let presenter = try self.unwrap().presenter.unwrap()
                presenter.reloadCollectionViewData()
            } catch {
                MolueLogger.UIModule.error(error)
            }
        }
    }
    
    private func updateAttacments(with attachments: [MLAttachmentDetail]) {
        if var oldAttachments = self.attachmentDetails {
            oldAttachments.append(contentsOf: attachments)
            self.attachmentDetails = oldAttachments
        } else {
            self.attachmentDetails = attachments
        }
        self.updateCurrentAttachment(with: self.attachmentDetails)
    }
    
    func updateCurrentAttachment(with attachments: [MLAttachmentDetail]?) {
        self.currentAttachment?.attachments = attachments
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
        defer { reload() }
        do {
            self.attachmentDetails?.remove(at: index)
            self.updateCurrentAttachment(with: self.attachmentDetails)
            let presenter = try self.presenter.unwrap()
            presenter.reloadCollectionViewData()
        } catch {
            MolueLogger.UIModule.message(error)
        }
        self.removePhoto(from: self.photoController, index: index)
    }
    func removePhoto(from controller: GalleryController?, index: Int) {
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
        for index in 0...attachments.count {
            do {
                let item = try attachments.item(at: index).unwrap()
                guard item.detailId.isNone() else { break }
                let task = uploadPhotoTask(with: item, index: index)
                try uploadTasks.append(task.unwrap())
            } catch { MolueLogger.network.message(error) }
        }
        return uploadTasks
    }
    
    func handleSuccessOperation() {
        do {
            let listener = try self.listener.unwrap()
            let updatedAttachment = try self.currentAttachment.unwrap()
            listener.updateCurrentAttachment(with: updatedAttachment)
            let router = try self.viewRouter.unwrap()
            router.popToPreviewController()
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
            let taskCompletionSource = TaskCompletionSource<Any?>()
            try self.presenter.unwrap().networkActivityStarted()
            let picture = try attachment.image.unwrap()
            MolueFileService.uploadPicture(with: picture, success: { [weak self] result in
                do {
                    let strongSelf = try self.unwrap()
                    try strongSelf.presenter.unwrap().networkActivitySuccess()
                    strongSelf.update(with: attachment, result: result, index: index)
                } catch { MolueLogger.network.message(error) }
                taskCompletionSource.set(result: result)
            }) { [weak self] (error) in
                do {
                    let presenter = try self.unwrap().presenter.unwrap()
                    presenter.networkActivityFailure(error: error)
                } catch { MolueLogger.network.message(error) }
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

extension TaskCheckDetailPageInteractor: TaskCheckDetailPresentableListener {
    func queryCurrentImageCount() -> Int? {
        do {
            let details = try self.attachmentDetails.unwrap()
            let imageCount: Int = details.count
            return imageCount >= maxImageCount ? maxImageCount : imageCount
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
            return imageCount >= maxImageCount ? maxImageCount : imageCount + 1
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
            try self.currentAttachment.unwrap().remark = remark
            let attachmentDetails = try self.attachmentDetails.unwrap()
            self.uploadAttachmentPhotos(with: attachmentDetails)
        } catch {
            MolueLogger.UIModule.message(error)
        }
    }
    
    func jumpToBrowserController(with index: Int) {
        do {
            let router = try self.viewRouter.unwrap()
            let attachments = try self.attachmentDetails.unwrap()
            let photoImages:[SKPhoto] = attachments.compactMap { attachment in
                do {
                    let image = try attachment.image.unwrap()
                    return SKPhoto.photoWithImage(image)
                } catch {
                    return MolueLogger.UIModule.allowNil(error)
                }
            }
            router.pushToPhotoBrowser(with: photoImages, index: index)
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    func jumpToTakePhotoController() {
        do {
            let viewRouter = try self.viewRouter.unwrap()
            let current = self.attachmentDetails?.count ?? 0
            let limit = self.maxImageCount - current
            viewRouter.pushToTakePhotoController(with: limit)
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
}
