//
//  RiskSchedulePageInteractor.swift
//  MolueRiskPart
//
//  Created by MolueJames on 2019/1/20.
//  Copyright © 2019 MolueTech. All rights reserved.
//

import RxSwift
import MolueMediator
import MolueUtilities

protocol RiskScheduleViewableRouting: class {
    // 定义一些页面跳转的方法, 比如Push, Presenter等.
    func pushToRiskDetailController()
}

protocol RiskSchedulePagePresentable: MolueInteractorPresentable {
    var listener: RiskSchedulePresentableListener? { get set }
    // 定义一些页面需要的方法, 比如刷新页面的显示内容等.
}

final class RiskSchedulePageInteractor: MoluePresenterInteractable {
    
    weak var presenter: RiskSchedulePagePresentable?
    
    var viewRouter: RiskScheduleViewableRouting?
    
    weak var listener: RiskScheduleInteractListener?
    
    private lazy var arrangeList: [MLPerilSituation]? = {
        do {
            let hiddenPeril = try self.hiddenPeril.unwrap()
            return try hiddenPeril.situations.unwrap()
        } catch {
            return MolueLogger.database.allowNil(error)
        }
    }()
    
    private let disposeBag = DisposeBag()
    
    lazy var hiddenPeril: MLHiddenPerilItem? = {
        do {
            let listener = try self.listener.unwrap()
            return try listener.hiddenPeril.unwrap()
        } catch {
            return MolueLogger.UIModule.allowNil(error)
        }
    }()
    
    required init(presenter: RiskSchedulePagePresentable) {
        self.presenter = presenter
        presenter.listener = self
    }
}

extension RiskSchedulePageInteractor: RiskScheduleRouterInteractable {
    
}

extension RiskSchedulePageInteractor: RiskSchedulePresentableListener {
    var moreCommand: PublishSubject<Void> {
        let moreInfoCommand = PublishSubject<Void>()
        moreInfoCommand.subscribe(onNext: { [unowned self] (_) in
            self.jumpToRiskDetailController()
        }).disposed(by: self.disposeBag)
        return moreInfoCommand
    }
    
    func jumpToRiskDetailController() {
        do {
            let router = try self.viewRouter.unwrap()
            router.pushToRiskDetailController()
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    func queryHiddenPeril() -> MLHiddenPerilItem? {
        do {
            return try self.hiddenPeril.unwrap()
        } catch {
            return MolueLogger.UIModule.allowNil(error)
        }
    }
    
    func queryRiskArrange(with indexPath: IndexPath) -> MLPerilSituation? {
//        do {
//            let arrangeList = try self.arrangeList.unwrap()
//            let filterList = arrangeList.filter { (item) -> Bool in
//                let filter = indexPath.section == 0 ? "done" : "created"
//                return item.status == filter
//            }
//            let item = filterList.item(at: indexPath.row)
//            return try item.unwrap()
//        } catch {
            return MolueLogger.UIModule.allowNil("error")
//        }
    }
    
    func numberOfRows(at section: Int) -> Int? {
        do {
            let arrangeList = try self.arrangeList.unwrap()
            return arrangeList.filter { (item) -> Bool in
                let filter = section == 0 ? "done" : "created"
                return item.status == filter
            }.count
        } catch {
            return MolueLogger.UIModule.allowNil(error)
        }
    }
}
