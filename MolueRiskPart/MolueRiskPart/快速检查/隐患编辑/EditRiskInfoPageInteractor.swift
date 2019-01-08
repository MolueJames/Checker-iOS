//
//  EditRiskInfoPageInteractor.swift
//  MolueRiskPart
//
//  Created by MolueJames on 2018/11/17.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import MolueFoundation
import MolueUtilities
import MolueNetwork
import Gallery
import Photos
import RxSwift
import BoltsSwift
import MolueCommon
import MolueMediator

protocol EditRiskInfoViewableRouting: class {
    // 定义一些页面跳转的方法, 比如Push, Presenter等.
    func pushToTakePhotoController(with limit: Int)
    func pushToPhotoBrowser(with photos: [SKPhoto], controller: UIViewController)
    func pushToPhotoBrowser(with photos: [SKPhoto], index: Int)
    func popToPreviewController()
}

protocol EditRiskInfoPagePresentable: MolueInteractorPresentable, MLControllerHUDProtocol, MolueActivityDelegate  {
    var listener: EditRiskInfoPresentableListener? { get set }
    // 定义一些页面需要的方法, 比如刷新页面的显示内容等.
    func reloadCollectionViewData()
}

final class EditRiskInfoPageInteractor: MoluePresenterInteractable {
    internal var maxImageCount: Int = 9
    
    weak var presenter: EditRiskInfoPagePresentable?
    
    var viewRouter: EditRiskInfoViewableRouting?
    
    weak var listener: EditRiskInfoInteractListener?
    
    private weak var photoController: GalleryController?
    
    lazy var detailRisk: MLRiskDetailUnit? = {
        do {
            let listener = try self.listener.unwrap()
            return try listener.detailRisk.unwrap()
        } catch {
            return MolueLogger.UIModule.allowNil(error)
        }
    }()
    
    lazy var attachment: MLTaskAttachment? = {
        do {
            let listener = try self.listener.unwrap()
            return try listener.attachment.unwrap()
        } catch {
            return MolueLogger.UIModule.allowNil(error)
        }
    }()
    
    lazy var attachmentDetails: [MLAttachmentDetail]? = {
        do {
            let attachment = try self.attachment.unwrap()
            return try attachment.attachments.unwrap()
        } catch {
            return MolueLogger.database.allowNil(error)
        }
    }()
    
    private let disposeBag = DisposeBag()
    
    required init(presenter: EditRiskInfoPagePresentable) {
        self.presenter = presenter
        presenter.listener = self
    }
}

extension EditRiskInfoPageInteractor: EditRiskInfoRouterInteractable {
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
        self.attachment?.attachments = attachments
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
            self.attachmentDetails?.remove(at: index)
            self.updateCurrentAttachment(with: self.attachmentDetails)
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
//            let listener = try self.listener.unwrap()
//            let updatedAttachment = try self.attachment.unwrap()
//            listener.updateCurrentAttachment(with: updatedAttachment)
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
                taskCompletionSource.set(result: result)
                do {
                    let strongSelf = try self.unwrap()
                    try strongSelf.presenter.unwrap().networkActivitySuccess()
                    strongSelf.update(with: attachment, result: result, index: index)
                } catch { MolueLogger.network.message(error) }
            }) { [weak self] (error) in
                taskCompletionSource.set(error: error)
                do {
                    let presenter = try self.unwrap().presenter.unwrap()
                    presenter.networkActivityFailure(error: error)
                } catch { MolueLogger.network.message(error) }
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

extension EditRiskInfoPageInteractor: EditRiskInfoPresentableListener {
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
    
    func queryCurrentImageCount() -> Int? {
        do {
            let details = try self.attachmentDetails.unwrap()
            let imageCount: Int = details.count
            return imageCount >= maxImageCount ? maxImageCount : imageCount
        } catch {
            return MolueLogger.UIModule.allowNil(error)
        }
    }
    
    func didSelectItemAt(indexPath: IndexPath) {
        let count = self.attachmentDetails?.count ?? 0
        if (indexPath.row < count) {
            self.jumpToBrowserController(with: indexPath.row)
        } else {
            self.jumpToTakePhotoController()
        }
    }
    
    func querySubmitCommand() -> PublishSubject<PotentialRiskModel> {
        let submitCommand = PublishSubject<PotentialRiskModel>()
        submitCommand.subscribe(onNext: { (item) in
            
        }, onError: { (error) in
            
        }).disposed(by: self.disposeBag)
        return submitCommand
    }
    
    func updateEditRiskInfo(with model: PotentialRiskModel) {
//        do {
//            let editModel: PotentialRiskModel = model
//            editModel.checkedRiskPhotos = self.photoImages
//
//            let listener = try self.listener.unwrap()
//            listener.updateEditRiskInfoModel(with: editModel)
//            self.doUpdateEditRiskInfoPresenter()
//        } catch {
//            MolueLogger.UIModule.error(error)
//        }
    }
    
    func doUpdateEditRiskInfoPresenter() {
        do {
            let presenter = try self.presenter.unwrap()
            presenter.showSuccessHUD(text: "隐患添加成功")
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
            let attachment = try self.attachmentDetails.unwrap()
            let photoImages:[SKPhoto] = attachment.compactMap { attachment in
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
