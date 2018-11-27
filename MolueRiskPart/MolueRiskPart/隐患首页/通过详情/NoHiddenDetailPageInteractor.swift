//
//  NoHiddenDetailPageInteractor.swift
//  MolueRiskPart
//
//  Created by JamesCheng on 2018-11-27.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import MolueMediator
import MolueUtilities
import MolueCommon

protocol NoHiddenDetailViewableRouting: class {
    // 定义一些页面跳转的方法, 比如Push, Presenter等.
    func pushToPhotoBrowser(with photos: [SKPhoto], index: Int)
}

protocol NoHiddenDetailPagePresentable: MolueInteractorPresentable {
    var listener: NoHiddenDetailPresentableListener? { get set }
    // 定义一些页面需要的方法, 比如刷新页面的显示内容等.
}

final class NoHiddenDetailPageInteractor: MoluePresenterInteractable {
    
    weak var presenter: NoHiddenDetailPagePresentable?
    
    var viewRouter: NoHiddenDetailViewableRouting?
    
    weak var listener: NoHiddenDetailInteractListener?
    
    lazy var taskDetail: TaskSuccessModel? = {
        return self.listener?.noHiddenItem
    }()
    
    lazy var noHiddenImages: [UIImage]? = {
        return self.taskDetail?.images
    }()
    
    required init(presenter: NoHiddenDetailPagePresentable) {
        self.presenter = presenter
        presenter.listener = self
    }
}

extension NoHiddenDetailPageInteractor: NoHiddenDetailRouterInteractable {
    
}

extension NoHiddenDetailPageInteractor: NoHiddenDetailPresentableListener {
    
    func jumpToBrowserController(with index: Int) {
        do {
            let taskDetail = try self.taskDetail.unwrap()
            let images = try taskDetail.images.unwrap()
            let photoImages:[SKPhoto] = images.map {
                SKPhoto.photoWithImage($0)
            }
            let router = try self.viewRouter.unwrap()
            router.pushToPhotoBrowser(with: photoImages, index: index)
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
}
