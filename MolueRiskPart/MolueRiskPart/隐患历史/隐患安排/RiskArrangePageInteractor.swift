//
//  RiskArrangePageInteractor.swift
//  MolueRiskPart
//
//  Created by JamesCheng on 2019-01-07.
//  Copyright © 2019 MolueTech. All rights reserved.
//

import RxSwift
import MolueCommon
import MolueNetwork
import MolueUtilities
import MolueFoundation
import MolueMediator

typealias RectifySteps = [[String : String]]

protocol RiskArrangeViewableRouting: class {
    // 定义一些页面跳转的方法, 比如Push, Presenter等.
    func presentDatePicker(with command: PublishSubject<(date: Date, string: String)>)
    
    func presentController(editor: UIAlertAction, delete: UIAlertAction, cancel: UIAlertAction)
    
    func pushToRiskDetailController()
    
    func pushToBudgetFromController(with list: [String], command: PublishSubject<String>)
}

protocol RiskArrangePagePresentable: MolueInteractorPresentable, MLControllerHUDProtocol, MolueActivityDelegate {
    var listener: RiskArrangePresentableListener? { get set }
    // 定义一些页面需要的方法, 比如刷新页面的显示内容等.
    func refreshFinishDate(with title: String)
    
    func refreshBudgetFrom(with title: String)
    
    func reloadTableViewCell()
}

final class RiskArrangePageInteractor: MoluePresenterInteractable {
    
    weak var presenter: RiskArrangePagePresentable?
    
    var viewRouter: RiskArrangeViewableRouting?
    
    weak var listener: RiskArrangeInteractListener?
    
    private let disposeBag = DisposeBag()
    
    private var selectedDate: Date?
    
    private var indexPath: IndexPath?
    
    private var needRectify: Bool = false
    
    lazy var hiddenPeril: MLHiddenPerilItem? = {
        do {
            let listener = try self.listener.unwrap()
            return try listener.hiddenPeril.unwrap()
        } catch {
            return MolueLogger.UIModule.allowNil(error)
        }
    }()
    
    required init(presenter: RiskArrangePagePresentable) {
        self.presenter = presenter
        presenter.listener = self
    }
}

extension RiskArrangePageInteractor: RiskArrangeRouterInteractable {
    
}

extension RiskArrangePageInteractor: RiskArrangePresentableListener {
    func queryDetailCommand() -> PublishSubject<Void> {
        let command: PublishSubject<Void> = PublishSubject<Void>()
        command.subscribe(onNext: { [unowned self] (_) in
            self.jumpToRiskDetailController()
        }).disposed(by: self.disposeBag)
        return command
    }
    
    func queryBudgetCommand() -> PublishSubject<Void> {
        let command: PublishSubject<Void> = PublishSubject<Void>()
        command.subscribe(onNext: { (_) in
            self.jumpToBudgetFromController()
        }).disposed(by: self.disposeBag)
        return command
    }
    
    func jumpToBudgetFromController() {
        do {
            let router = try self.viewRouter.unwrap()
            let list: [String] = ["企业自有资金", "政府补贴资金"]
            let command = PublishSubject<String>()
            command.subscribe(onNext: { [unowned self] (from) in
                self.updateFooterViewBudgetFrom(with: from)
            }).disposed(by: self.disposeBag)
            router.pushToBudgetFromController(with: list, command: command)
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    func updateFooterViewBudgetFrom(with from: String) {
        do {
            let presenter = try self.presenter.unwrap()
            presenter.refreshBudgetFrom(with: from)
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    func querySubmitCommand() -> PublishSubject<Void> {
        let command: PublishSubject<Void> = PublishSubject<Void>()
        
        return command
    }
    
    func queryFinishCommand() -> PublishSubject<Void> {
        let command: PublishSubject<Void> = PublishSubject<Void>()
        command.subscribe(onNext: { [unowned self] (_) in
            self.footerViewFinishOperation()
        }).disposed(by: self.disposeBag)
        return command
    }
    
    func footerViewFinishOperation() {
        do {
            let router = try self.viewRouter.unwrap()
            let command = self.queryFinishDateCommand()
            router.presentDatePicker(with: command)
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    func querySituation(with indexPath: IndexPath) -> MLPerilSituation? {
        do {
            let hiddenPeril = try self.hiddenPeril.unwrap()
            let situations = try hiddenPeril.situations.unwrap()
            let situation = situations.item(at: indexPath.row)
            return try situation.unwrap()
        } catch {
            return MolueLogger.UIModule.returnNil(error)
        }
    }
    
    func uploadHiddenPerilArrange() {
        do {
            let parameters = try self.createParameters().unwrap()
            let hiddenPeril = try self.hiddenPeril.unwrap()
            let perilId = try hiddenPeril.perilId.unwrap()
            let request = MoluePerilService.uploadRectifySteps(with: parameters, perilId: perilId)
            request.handleSuccessResponse { (result) in
                MolueLogger.network.message(result)
            }
            let manager = MolueRequestManager(delegate: self.presenter)
            manager.doRequestStart(with: request)
        } catch { MolueLogger.UIModule.message(error) }
    }
    
    func createSelectedDate() throws -> String? {
        guard self.needRectify == true else {
            return MolueLogger.UIModule.allowNil("")
        }
        guard let date = self.selectedDate else {
            throw MolueCommonError(with: "请选择截止日期")
        }
        return date.string(withFormat: "yyyy-MM-dd")
    }
    
    func createParameters() -> [String : Any]? {
//        do {
//            var parameters: [String : Any] = [String : Any]()
//            let rectifySteps = try self.createArrangeList()
//            parameters["rectify_steps"] = rectifySteps
//            let rectifyDate = try self.createSelectedDate()
//            parameters["rectify_date"] = rectifyDate
//            parameters["need_rectification"] = self.needRectify
//            return parameters
//        } catch {
//            let message = error.localizedDescription
//            self.showWarningMessage(with: message)
//            return MolueLogger.network.allowNil(error)
//        }
        return nil
    }
    
    func showWarningMessage(with message: String) {
        do {
            let presenter = try self.presenter.unwrap()
            presenter.showWarningHUD(text: message)
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    func jumpToRiskDetailController() {
        do {
            let router = try self.viewRouter.unwrap()
            router.pushToRiskDetailController()
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    func numberOfRows(at section: Int) -> Int? {
        do {
            let hiddenPeril = try self.hiddenPeril.unwrap()
            return try hiddenPeril.situations.unwrap().count
        } catch {
            return MolueLogger.UIModule.allowNil(error)
        }
    }
    
    func queryFinishDateCommand() -> PublishSubject<(date: Date, string: String)> {
        let command = PublishSubject<(date: Date, string: String)>()
        command.subscribe(onNext: { [unowned self] (date, title) in
            self.updatePerilFinishDate(with: date, title: title)
        }).disposed(by: self.disposeBag)
        return command
    }
    
    func updatePerilFinishDate(with date: Date, title: String) {
        do {
            let presenter = try self.presenter.unwrap()
            presenter.refreshFinishDate(with: title)
            self.selectedDate = date
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
}
