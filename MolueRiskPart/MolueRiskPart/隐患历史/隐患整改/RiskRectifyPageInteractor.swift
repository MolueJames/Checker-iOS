//
//  RiskRectifyPageInteractor.swift
//  MolueRiskPart
//
//  Created by MolueJames on 2018/11/7.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import RxSwift
import MolueMediator
import MolueUtilities

protocol RiskRectifyViewableRouting: class {
    // 定义一些页面跳转的方法, 比如Push, Presenter等.
    func pushToRiskDetailController()
}

protocol RiskRectifyPagePresentable: MolueInteractorPresentable {
    var listener: RiskRectifyPresentableListener? { get set }
    // 定义一些页面需要的方法, 比如刷新页面的显示内容等.
}

final class RiskRectifyPageInteractor: MoluePresenterInteractable {
    
    weak var presenter: RiskRectifyPagePresentable?
    
    var viewRouter: RiskRectifyViewableRouting?
    
    weak var listener: RiskRectifyInteractListener?
    
    lazy var rectifyStep: [MLPerilRectifyStep]? = {
        do {
            let hiddenPeril = try self.hiddenPeril.unwrap()
            return try hiddenPeril.rectifySteps.unwrap()
        } catch {
            return MolueLogger.UIModule.allowNil(error)
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
    
    required init(presenter: RiskRectifyPagePresentable) {
        self.presenter = presenter
        presenter.listener = self
    }
}

extension RiskRectifyPageInteractor: RiskRectifyRouterInteractable {
    
}

extension RiskRectifyPageInteractor: RiskRectifyPresentableListener {
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
    
    func queryRiskArrange(with indexPath: IndexPath) -> MLPerilRectifyStep? {
        do {
            let arrangeList = try self.rectifyStep.unwrap()
            let filterList = arrangeList.filter { (item) -> Bool in
                let filter = indexPath.section == 0 ? "done" : "created"
                return item.status == filter
            }
            let item = filterList.item(at: indexPath.row)
            return try item.unwrap()
        } catch {
            return MolueLogger.UIModule.allowNil(error)
        }
    }
    
    func numberOfRows(at section: Int) -> Int? {
        do {
            let arrangeList = try self.rectifyStep.unwrap()
            return arrangeList.filter { (item) -> Bool in
                let filter = section == 0 ? "done" : "created"
                return item.status == filter
            }.count
        } catch {
            return MolueLogger.UIModule.allowNil(error)
        }
    }
}
