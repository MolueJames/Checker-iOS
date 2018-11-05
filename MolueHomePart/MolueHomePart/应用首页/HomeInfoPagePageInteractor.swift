//
//  HomeInfoPagePageInteractor.swift
//  MolueHomePart
//
//  Created by JamesCheng on 2018-11-05.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import MolueMediator
import MolueUtilities

protocol HomeInfoPageViewableRouting: class {
    // 定义一些页面跳转的方法, 比如Push, Presenter等.
    func pushToDailyTaskController()
    
    func pushToRiskCheckController()
    
    func pushToNoticationController()
    
    func pushToLegislationController()
    
    func pushToEducationController()
    
    func pushToDataRecordController()
}

protocol HomeInfoPagePagePresentable: MolueInteractorPresentable {
    var listener: HomeInfoPagePresentableListener? { get set }
    // 定义一些页面需要的方法, 比如刷新页面的显示内容等.
}

final class HomeInfoPagePageInteractor: MoluePresenterInteractable {
    
    weak var presenter: HomeInfoPagePagePresentable?
    
    var viewRouter: HomeInfoPageViewableRouting?
    
    weak var listener: HomeInfoPageInteractListener?
    
    var valueList: [String] = ["1","2","3","4"]
    
    required init(presenter: HomeInfoPagePagePresentable) {
        self.presenter = presenter
        presenter.listener = self
    }
    
}

extension HomeInfoPagePageInteractor: HomeInfoPageRouterInteractable {
    
}

extension HomeInfoPagePageInteractor: HomeInfoPagePresentableListener {
    func jumpToDailyTaskController() {
        do {
            let viewRouter = try self.viewRouter.unwrap()
            viewRouter.pushToDailyTaskController()
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    func jumpToRiskCheckController() {
        do {
            let viewRouter = try self.viewRouter.unwrap()
            viewRouter.pushToRiskCheckController()
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    func jumpToNoticationController() {
        do {
            let viewRouter = try self.viewRouter.unwrap()
            viewRouter.pushToNoticationController()
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    func jumpToLegislationController() {
        do {
            let viewRouter = try self.viewRouter.unwrap()
            viewRouter.pushToLegislationController()
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    func jumpToEducationController() {
        do {
            let viewRouter = try self.viewRouter.unwrap()
            viewRouter.pushToEducationController()
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    func jumpToDataRecordController() {
        do {
            let viewRouter = try self.viewRouter.unwrap()
            viewRouter.pushToDataRecordController()
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    func bindingTableViewAdapter(with tableView: UITableView) {
        
    }
}
