//
//  AdvertiseContentPageInteractor.swift
//  MolueHomePart
//
//  Created by MolueJames on 2019/1/15.
//  Copyright © 2019 MolueTech. All rights reserved.
//

import MolueUtilities
import MolueMediator

protocol AdvertiseContentViewableRouting: class {
    // 定义一些页面跳转的方法, 比如Push, Presenter等.
}

protocol AdvertiseContentPagePresentable: MolueInteractorPresentable {
    var listener: AdvertiseContentPresentableListener? { get set }
    // 定义一些页面需要的方法, 比如刷新页面的显示内容等.
}

final class AdvertiseContentPageInteractor: MoluePresenterInteractable {
    
    weak var presenter: AdvertiseContentPagePresentable?
    
    var viewRouter: AdvertiseContentViewableRouting?
    
    weak var listener: AdvertiseContentInteractListener?
    
    lazy var advertisement: MLAdvertiseContent? = {
        do {
            let listener = try self.listener.unwrap()
            return try listener.advertisement.unwrap()
        } catch {
            return MolueLogger.UIModule.allowNil(error)
        }
    }()
    
    required init(presenter: AdvertiseContentPagePresentable) {
        self.presenter = presenter
        presenter.listener = self
    }
}

extension AdvertiseContentPageInteractor: AdvertiseContentRouterInteractable {
    
}

extension AdvertiseContentPageInteractor: AdvertiseContentPresentableListener {
    
}
