//
//  HomeInfoPagePageInteractor.swift
//  MolueHomePart
//
//  Created by JamesCheng on 2018-11-05.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import MolueMediator
import MolueNetwork
import MolueUtilities
import RxSwift

protocol HomeInfoPageViewableRouting: class {
    // 定义一些页面跳转的方法, 比如Push, Presenter等.
    func pushToDailyTaskController()
    
    func pushToRiskCheckController()
    
    func pushToNoticationController()
    
    func pushToLegislationController()
    
    func pushToRiskHistoryController()
    
    func pushToDangerListController()
}

protocol HomeInfoPagePagePresentable: MolueInteractorPresentable {
    var listener: HomeInfoPagePresentableListener? { get set }
    // 定义一些页面需要的方法, 比如刷新页面的显示内容等.
    func refreshBannerList(with advertisement: [MLAdvertisement])
}

final class HomeInfoPagePageInteractor: MoluePresenterInteractable {
    
    weak var presenter: HomeInfoPagePagePresentable?
    
    var viewRouter: HomeInfoPageViewableRouting?
    
    weak var listener: HomeInfoPageInteractListener?
    
    var detailRisk: MLRiskPointDetail?
    
    var attachment: MLTaskAttachment?
    
    var bannerList = MolueListItem<MLAdvertisement>()
    
    required init(presenter: HomeInfoPagePagePresentable) {
        self.presenter = presenter
        presenter.listener = self
    }
    var measureItem: RiskMeasureModel?
    
    private let disposeBag = DisposeBag()
}

extension HomeInfoPagePageInteractor: HomeInfoPageRouterInteractable {
    func removeSelectedItemAtIndexPath() {
        
    }
}

extension HomeInfoPagePageInteractor: HomeInfoPagePresentableListener {
    func queryDailyTaskCommand() -> PublishSubject<Void> {
        let command = PublishSubject<Void>()
        command.subscribe(onNext: { [unowned self] () in
            self.jumpToDailyTaskController()
        }).disposed(by: self.disposeBag)
        return command
    }
    
    func queryRiskCheckCommand() -> PublishSubject<Void> {
        let command = PublishSubject<Void>()
        command.subscribe(onNext: { [unowned self] () in
            self.jumpToRiskCheckController()
        }).disposed(by: self.disposeBag)
        return command
    }
    
    func queryNotificationCommand() -> PublishSubject<Void> {
        let command = PublishSubject<Void>()
        command.subscribe(onNext: { [unowned self] () in
            self.jumpToNoticationController()
        }).disposed(by: self.disposeBag)
        return command
    }
    
    func queryLegislationCommand() -> PublishSubject<Void> {
        let command = PublishSubject<Void>()
        command.subscribe(onNext: { [unowned self] () in
            self.jumpToLegislationController()
        }).disposed(by: self.disposeBag)
        return command
    }
    
    func queryRiskHistoryCommand() -> PublishSubject<Void> {
        let command = PublishSubject<Void>()
        command.subscribe(onNext: { [unowned self] () in
            self.jumpToRiskHistoryController()
        }).disposed(by: self.disposeBag)
        return command
    }
    
    func queryDangerListCommand() -> PublishSubject<Void> {
        let command = PublishSubject<Void>()
        command.subscribe(onNext: { [unowned self] () in
            self.jumpToDangerListController()
        }).disposed(by: self.disposeBag)
        return command
    }
    
    func queryAdvertisementList() {
        let request = MolueOtherService.queryAdvertisement(with: "Home", platform: "iOS")
        request.handleSuccessResultToObjc { [weak self] (result: MolueListItem<MLAdvertisement>?) in
            do {
                let strongSelf = try self.unwrap()
                let listModel = try result.unwrap()
                strongSelf.handleAdvertisement(with: listModel)
            } catch {
                MolueLogger.network.message(error)
            }
        }
        MolueRequestManager().doRequestStart(with: request)
    }
    
    func handleAdvertisement(with item: MolueListItem<MLAdvertisement>) {
        do {
            let presenter = try self.presenter.unwrap()
            let itemList = try item.results.unwrap()
            presenter.refreshBannerList(with: itemList)
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    func jumpToRiskHistoryController() {
        do {
            let viewRouter = try self.viewRouter.unwrap()
            viewRouter.pushToRiskHistoryController()
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    func jumpToDangerListController() {
        do {
            let viewRouter = try self.viewRouter.unwrap()
            viewRouter.pushToDangerListController()
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
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
}
