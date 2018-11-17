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
}

protocol QuickCheckRiskPagePresentable: MolueInteractorPresentable {
    var listener: QuickCheckRiskPresentableListener? { get set }
    // 定义一些页面需要的方法, 比如刷新页面的显示内容等.
}

final class QuickCheckRiskPageInteractor: MoluePresenterInteractable {
    
    weak var presenter: QuickCheckRiskPagePresentable?
    
    var viewRouter: QuickCheckRiskViewableRouting?
    
    weak var listener: QuickCheckRiskInteractListener?
    
    required init(presenter: QuickCheckRiskPagePresentable) {
        self.presenter = presenter
        presenter.listener = self
    }
}

extension QuickCheckRiskPageInteractor: QuickCheckRiskRouterInteractable {
    
}

extension QuickCheckRiskPageInteractor: QuickCheckRiskPresentableListener {
    func jumpToPhotoBrowser(with images: [Image], controller: UIViewController) {
        Image.resolve(images: images) { [weak self] resolvedImages in
            do {
                let images = resolvedImages.compactMap({$0})
                try self.unwrap().showPhotoBrowser(images: images, controller: controller)
            } catch {
                MolueLogger.UIModule.error(error)
            }
        }
    }
    
    func showPhotoBrowser(images: [UIImage], controller: UIViewController){
        guard images.count > 0 else {return}
        let photoImages:[SKPhoto] = images.map {
            SKPhoto.photoWithImage($0)
        }
        do {
            let viewRouter = try self.viewRouter.unwrap()
            viewRouter.pushToPhotoBrowser(with: photoImages, controller: controller)
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
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
