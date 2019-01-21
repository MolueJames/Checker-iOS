//
//  RiskPlanedPageInteractor.swift
//  MolueRiskPart
//
//  Created by JamesCheng on 2019-01-21.
//  Copyright © 2019 MolueTech. All rights reserved.
//

import RxSwift
import MolueMediator
import MolueUtilities

protocol RiskPlanedViewableRouting: class {
    // 定义一些页面跳转的方法, 比如Push, Presenter等.
    func pushToRiskDetailController()
}

protocol RiskPlanedPagePresentable: MolueInteractorPresentable {
    var listener: RiskPlanedPresentableListener? { get set }
    // 定义一些页面需要的方法, 比如刷新页面的显示内容等.
}

final class RiskPlanedPageInteractor: MoluePresenterInteractable {
    
    weak var presenter: RiskPlanedPagePresentable?
    
    var viewRouter: RiskPlanedViewableRouting?
    
    weak var listener: RiskPlanedInteractListener?
    
    private lazy var arrangeList: [MLPerilRectifyStep]? = {
        do {
            let hiddenPeril = try self.hiddenPeril.unwrap()
            return try hiddenPeril.rectifySteps.unwrap()
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
    
    required init(presenter: RiskPlanedPagePresentable) {
        self.presenter = presenter
        presenter.listener = self
    }
}

extension RiskPlanedPageInteractor: RiskPlanedRouterInteractable {
    
}

extension RiskPlanedPageInteractor: RiskPlanedPresentableListener {
    func queryHiddenPeril() -> MLHiddenPerilItem? {
        do {
            return try self.hiddenPeril.unwrap()
        } catch {
            return MolueLogger.UIModule.allowNil(error)
        }
    }
    
    func queryRiskArrange(with indexPath: IndexPath) -> MLPerilRectifyStep? {
        do {
            let arrangeList = try self.arrangeList.unwrap()
            let item = arrangeList.item(at: indexPath.row)
            return try item.unwrap()
        } catch {
            return MolueLogger.UIModule.allowNil(error)
        }
    }
    
    func numberOfRows(at section: Int) -> Int? {
        do {
            let arrangeList = try self.arrangeList.unwrap()
            return arrangeList.count
        } catch {
            return MolueLogger.UIModule.allowNil(error)
        }
    }
    
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
    
}
