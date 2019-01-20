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
    
    func pushToMinePerilController()
    
    func pushToNoticationController()
    
    func pushToLegislationController()
    
    func pushToRiskHistoryController()
    
    func pushToDangerListController()
    
    func pushToAdvertisementController()
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
    
    var advertisement: MLAdvertiseContent?
    
    required init(presenter: HomeInfoPagePagePresentable) {
        self.presenter = presenter
        presenter.listener = self
    }
    
    private let disposeBag = DisposeBag()
}

extension HomeInfoPagePageInteractor: HomeInfoPageRouterInteractable {
    func removeSelectedItemAtIndexPath() {
        
    }
}

extension HomeInfoPagePageInteractor: HomeInfoPagePresentableListener {
    func didSelectRow(at indexPath: IndexPath) {
        MolueLogger.UIModule.message("")
    }
    
    func numberOfRows(in section: Int) -> Int? {
        return 2
    }
    
    func queryMinePerilCommand() -> PublishSubject<Void> {
        let command = PublishSubject<Void>()
        command.subscribe(onNext: { [unowned self] () in
            self.jumpToMinePerilController()
        }).disposed(by: self.disposeBag)
        return command
    }
    
    func querySelectedCommand() -> PublishSubject<MLAdvertiseContent> {
        let command = PublishSubject<MLAdvertiseContent>()
        command.subscribe(onNext: { [unowned self] (advertisement) in
            self.jumpToAdvertisementController(with: advertisement)
        }).disposed(by: self.disposeBag)
        return command
    }
    
    func queryDailyTaskCommand() -> PublishSubject<Void> {
        let command = PublishSubject<Void>()
        command.subscribe(onNext: { [unowned self] () in
            self.jumpToDailyTaskController()
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
            let router = try self.viewRouter.unwrap()
            router.pushToRiskHistoryController()
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    func jumpToDangerListController() {
        do {
            let router = try self.viewRouter.unwrap()
            router.pushToDangerListController()
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    func jumpToDailyTaskController() {
        do {
            let router = try self.viewRouter.unwrap()
            router.pushToDailyTaskController()
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    func jumpToMinePerilController() {
        do {
            let router = try self.viewRouter.unwrap()
            router.pushToMinePerilController()
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    func jumpToNoticationController() {
        do {
            let router = try self.viewRouter.unwrap()
            router.pushToNoticationController()
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    func jumpToLegislationController() {
        do {
            let router = try self.viewRouter.unwrap()
            router.pushToLegislationController()
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    func jumpToAdvertisementController(with advertisement: MLAdvertiseContent) {
        do {
            self.advertisement = advertisement
            let router = try self.viewRouter.unwrap()
            router.pushToAdvertisementController()
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
}
