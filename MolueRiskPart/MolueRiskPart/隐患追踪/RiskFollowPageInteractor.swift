//
//  RiskFollowPageInteractor.swift
//  MolueRiskPart
//
//  Created by MolueJames on 2019/1/21.
//  Copyright © 2019 MolueTech. All rights reserved.
//

import RxSwift
import MolueNetwork
import MolueFoundation
import MolueUtilities
import MolueMediator

protocol RiskFollowViewableRouting: class {
    // 定义一些页面跳转的方法, 比如Push, Presenter等.
    func pushToRiskDetailController()
}

protocol RiskFollowPagePresentable: MolueInteractorPresentable, MLControllerHUDProtocol {
    var listener: RiskFollowPresentableListener? { get set }
    // 定义一些页面需要的方法, 比如刷新页面的显示内容等.
    func refreshHeaderView(with item: MLHiddenPerilItem)
    
    func clearTableHeaderView()
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
    
    var hiddenPeril: MLHiddenPerilItem?
    
    required init(presenter: RiskFollowPagePresentable) {
        self.presenter = presenter
        presenter.listener = self
    }
}

extension RiskFollowPageInteractor: RiskFollowRouterInteractable {
    
}

extension RiskFollowPageInteractor: RiskFollowPresentableListener {
    func searchHiddenPeril(with text: String) {
        if text.isEmpty == false {
            let request = MoluePerilService.queryPerilDetail(with: text)
            request.handleSuccessResultToObjc { [weak self] (result: MLHiddenPerilItem?) in
                do {
                    let strongSelf = try self.unwrap()
                    strongSelf.handleSuccessResult(with: result)
                } catch { MolueLogger.network.message(error) }
            }
            request.handleFailureResponse { [weak self] (error) in
                do {
                    let strongSelf = try self.unwrap()
                    strongSelf.handleFailureResult(with: error)
                } catch { MolueLogger.network.message(error) }
            }
            MolueRequestManager().doRequestStart(with: request)
        } else {
            self.showWarningMessage(with: "请输入隐患编号")
        }
    }
    
    func showWarningMessage(with message: String) {
        do {
            let presenter = try self.presenter.unwrap()
            presenter.showWarningHUD(text: message)
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    func handleFailureResult(with error: Error) {
        
        do {
            let presenter = try self.presenter.unwrap()
            self.hiddenPeril = nil
            let message = self.queryErrorMessage(with: error)
            presenter.showFailureHUD(text: message)
            presenter.clearTableHeaderView()
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    func queryErrorMessage(with error: Error) -> String {
        switch error {
        case MolueStatusError.requestIsNotExisted:
            return "未找到对应的隐患"
        default:
            return error.localizedDescription
        }
    }
    
    func handleSuccessResult(with result: MLHiddenPerilItem?) {
        do {
            let presenter = try self.presenter.unwrap()
            let hiddenPeril = try result.unwrap()
            self.hiddenPeril = hiddenPeril
            presenter.refreshHeaderView(with: hiddenPeril)
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
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
