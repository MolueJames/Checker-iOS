//
//  EditRiskInfoPageInteractor.swift
//  MolueRiskPart
//
//  Created by MolueJames on 2018/11/17.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import MolueMediator

protocol EditRiskInfoViewableRouting: class {
    // 定义一些页面跳转的方法, 比如Push, Presenter等.
}

protocol EditRiskInfoPagePresentable: MolueInteractorPresentable {
    var listener: EditRiskInfoPresentableListener? { get set }
    // 定义一些页面需要的方法, 比如刷新页面的显示内容等.
}

final class EditRiskInfoPageInteractor: MoluePresenterInteractable {
    
    weak var presenter: EditRiskInfoPagePresentable?
    
    var viewRouter: EditRiskInfoViewableRouting?
    
    weak var listener: EditRiskInfoInteractListener?
    
    required init(presenter: EditRiskInfoPagePresentable) {
        self.presenter = presenter
        presenter.listener = self
    }
}

extension EditRiskInfoPageInteractor: EditRiskInfoRouterInteractable {
    
}

extension EditRiskInfoPageInteractor: EditRiskInfoPresentableListener {
    func queryNeedEditRiskImages() -> [UIImage] {
        do {
            let listener = try self.listener.unwrap()
            return try listener.photoImages.unwrap()
        } catch { return [UIImage]() }
    }
}
