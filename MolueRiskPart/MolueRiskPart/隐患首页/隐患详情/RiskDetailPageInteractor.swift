//
//  RiskDetailPageInteractor.swift
//  MolueRiskPart
//
//  Created by MolueJames on 2018/11/7.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import MolueMediator
import MolueUtilities
import MolueCommon

protocol RiskDetailViewableRouting: class {
    // 定义一些页面跳转的方法, 比如Push, Presenter等.
    func pushToPhotoBrowser(with photos: [SKPhoto], index: Int)
}

protocol RiskDetailPagePresentable: MolueInteractorPresentable {
    var listener: RiskDetailPresentableListener? { get set }
    // 定义一些页面需要的方法, 比如刷新页面的显示内容等.
}

final class RiskDetailPageInteractor: MoluePresenterInteractable {
    
    weak var presenter: RiskDetailPagePresentable?
    
    var viewRouter: RiskDetailViewableRouting?
    
    weak var listener: RiskDetailInteractListener?
    
    lazy var riskDetail: PotentialRiskModel? = {
        return self.listener?.selectedRisk
    }()
    
    lazy var riskDetailImages: [UIImage]? = {
        return self.riskDetail?.checkedRiskPhotos
    }()
    
    required init(presenter: RiskDetailPagePresentable) {
        self.presenter = presenter
        presenter.listener = self
    }
}

extension RiskDetailPageInteractor: RiskDetailRouterInteractable {
    
}

extension RiskDetailPageInteractor: RiskDetailPresentableListener {
    
    
    func jumpToBrowserController(with index: Int) {
        do {
            let riskDetail = try self.riskDetail.unwrap()
            let images = try riskDetail.checkedRiskPhotos.unwrap()
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
