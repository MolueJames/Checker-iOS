//
//  RiskFollowPageInteractor.swift
//  MolueRiskPart
//
//  Created by MolueJames on 2019/1/21.
//  Copyright © 2019 MolueTech. All rights reserved.
//

import RxSwift
import MolueUtilities
import MolueMediator

protocol RiskFollowViewableRouting: class {
    // 定义一些页面跳转的方法, 比如Push, Presenter等.
    func pushToRiskDetailController()
}

protocol RiskFollowPagePresentable: MolueInteractorPresentable {
    var listener: RiskFollowPresentableListener? { get set }
    // 定义一些页面需要的方法, 比如刷新页面的显示内容等.
}

final class RiskFollowPageInteractor: MoluePresenterInteractable {
    
    weak var presenter: RiskFollowPagePresentable?
    
    var viewRouter: RiskFollowViewableRouting?
    
    weak var listener: RiskFollowInteractListener?
    
    private let disposeBag = DisposeBag()
    
    lazy var perilActions: [MLHiddenPerilAction] = {
        do {
            let hiddenPeril = try self.hiddenPeril.unwrap()
            let actions = try hiddenPeril.actions.unwrap()
            return self.combineActions(with: actions)
        } catch {
            return PotentialRiskStatus.defaultActions()
        }
    }()
    
    func combineActions(with actions: [MLHiddenPerilAction]) -> [MLHiddenPerilAction] {
        var defaults = PotentialRiskStatus.defaultActions()
        if actions.count >= defaults.count {
            return actions
        }
        for index in 0...actions.count {
            do {
                let item = actions.item(at: index)
                defaults[index] = try item.unwrap()
            } catch {
                MolueLogger.UIModule.message(error)
            }
        }
        return defaults
    }
    
    lazy var hiddenPeril: MLHiddenPerilItem? = {
        do {
            let listener = try self.listener.unwrap()
            return try listener.hiddenPeril.unwrap()
        } catch {
            return MolueLogger.UIModule.allowNil(error)
        }
    }()
    
    required init(presenter: RiskFollowPagePresentable) {
        self.presenter = presenter
        presenter.listener = self
    }
}

extension RiskFollowPageInteractor: RiskFollowRouterInteractable {
    
}

extension RiskFollowPageInteractor: RiskFollowPresentableListener {
    func numberOfRows(in section: Int) -> Int {
        do {
            let hiddenPeril = try self.hiddenPeril.unwrap()
            let count = try hiddenPeril.actions.unwrap().count
            return count < 4 ? 4 : count
        } catch { return 0 }
    }
    
    func queryHiddenPeril() -> MLHiddenPerilItem? {
        do {
            return try self.hiddenPeril.unwrap()
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
    
    func queryPerilAction(with indexPath: IndexPath) -> MLHiddenPerilAction? {
        do {
            let item = self.perilActions.item(at: indexPath.row)
            return try item.unwrap()
        } catch {
            return MolueLogger.UIModule.allowNil(error)
        }
    }
}
