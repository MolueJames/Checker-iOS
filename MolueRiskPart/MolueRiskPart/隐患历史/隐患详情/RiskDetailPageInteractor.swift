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
    func pushToPhotoBrowser(with photos: [KFPhoto], index: Int)
}

protocol RiskDetailPagePresentable: MolueInteractorPresentable {
    var listener: RiskDetailPresentableListener? { get set }
    // 定义一些页面需要的方法, 比如刷新页面的显示内容等.
}

final class RiskDetailPageInteractor: MoluePresenterInteractable {
    
    weak var presenter: RiskDetailPagePresentable?
    
    var viewRouter: RiskDetailViewableRouting?
    
    weak var listener: RiskDetailInteractListener?
    
    lazy var hiddenPeril: MLHiddenPerilItem? = {
        do {
            let listener = try self.listener.unwrap()
            return try listener.hiddenPeril.unwrap()
        } catch {
            return MolueLogger.database.allowNil(error)
        }
    }()
    
    required init(presenter: RiskDetailPagePresentable) {
        self.presenter = presenter
        presenter.listener = self
    }
}

extension RiskDetailPageInteractor: RiskDetailRouterInteractable {
    
}

extension RiskDetailPageInteractor: RiskDetailPresentableListener {
    func queryPerilSituation(with indexPath: IndexPath) -> String? {
        do {
            let hiddenPeril = try self.hiddenPeril.unwrap()
            let situations = try hiddenPeril.situations.unwrap()
            let situation = situations.item(at: indexPath.row)
            return try situation.unwrap().content.unwrap()
        } catch {
            return MolueLogger.UIModule.allowNil(error)
        }
    }
    
    func numberOfItems(in section: Int) -> Int? {
        do {
            let hiddenPeril = try self.hiddenPeril.unwrap()
            if section == 0 {
                return try hiddenPeril.attachments.unwrap().count
            } else {
                return try hiddenPeril.situations.unwrap().count
            }
        } catch {
            return MolueLogger.UIModule.allowNil(error)
        }
    }
    
    func queryPerilAttachment(with indexPath: IndexPath) -> String? {
        do {
            let hiddenPeril = try self.hiddenPeril.unwrap()
            let attachments = try hiddenPeril.attachments.unwrap()
            let attachment = attachments.item(at: indexPath.row)
            return try attachment.unwrap().urlPath.unwrap()
        } catch {
            return MolueLogger.UIModule.allowNil(error)
        }
    }
    
    func queryHiddenPeril() -> MLHiddenPerilItem? {
        do {
            return try self.hiddenPeril.unwrap()
        } catch {
            return MolueLogger.UIModule.allowNil(error)
        }
    }
    
    func jumpToBrowserController(with indexPath: IndexPath) {
        do {
            guard indexPath.section == 0 else { return }
            let hiddenPeril = try self.hiddenPeril.unwrap()
            let attachments = try hiddenPeril.attachments.unwrap()
            let images: [KFPhoto] = attachments.compactMap { (attachment) in
                do {
                    return try KFPhoto(url: attachment.urlPath.unwrap())
                } catch {return MolueLogger.UIModule.allowNil(error)}
            }
            let router = try self.viewRouter.unwrap()
            router.pushToPhotoBrowser(with: images, index: indexPath.row)
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
}
