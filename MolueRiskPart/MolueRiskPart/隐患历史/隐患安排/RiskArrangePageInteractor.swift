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
}

protocol RiskArrangePagePresentable: MolueInteractorPresentable, MLControllerHUDProtocol, MolueActivityDelegate {
    var listener: RiskArrangePresentableListener? { get set }
    // 定义一些页面需要的方法, 比如刷新页面的显示内容等.
    func refreshFooterViewSelected(with title: String)
    
    func reloadTableViewCell()
    
    func insertTableViewCell()
    
    func displayEditorFooterView()
    
    func displayInsertFooterView()
    
    func editFooterView(with text: String)
}

final class RiskArrangePageInteractor: MoluePresenterInteractable {
    
    weak var presenter: RiskArrangePagePresentable?
    
    var viewRouter: RiskArrangeViewableRouting?
    
    weak var listener: RiskArrangeInteractListener?
    
    private let disposeBag = DisposeBag()
    
    private var selectedDate: Date?
    
    private var indexPath: IndexPath?
    
    private var arrangeList = [String]()
    
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
    
    func createArrangeList() throws -> RectifySteps {
        guard self.arrangeList.count > 0 else {
            throw MolueCommonError(with: "请添加隐患整改步骤")
        }
        return self.arrangeList.compactMap { (step) in
            return ["title" : step]
        }
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
        do {
            var parameters: [String : Any] = [String : Any]()
            let rectifySteps = try self.createArrangeList()
            parameters["rectify_steps"] = rectifySteps
            let rectifyDate = try self.createSelectedDate()
            parameters["rectify_date"] = rectifyDate
            parameters["need_rectification"] = self.needRectify
            return parameters
        } catch {
            let message = error.localizedDescription
            self.showWarningMessage(with: message)
            return MolueLogger.network.allowNil(error)
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
    
    func didSelectRow(at indexPath: IndexPath) {
        do {
            let editor = UIAlertAction(title: "编辑步骤", style: .default) { [unowned self] _ in
                self.editPreviousArrange(at: indexPath)
            }
            let delete = UIAlertAction(title: "删除步骤", style: .destructive) { [unowned self] _ in
                self.deleteEditedArrange(at: indexPath)
            }
            let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            let router = try self.viewRouter.unwrap()
            router.presentController(editor: editor, delete: delete, cancel: cancel)
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    func deleteEditedArrange(at indexPath: IndexPath) {
        do {
            self.arrangeList.remove(at: indexPath.row)
            let presenter = try self.presenter.unwrap()
            presenter.reloadTableViewCell()
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    func editPreviousArrange(at indexPath: IndexPath) {
        do {
            let remark = self.queryRiskArrange(with: indexPath)
            let presenter = try self.presenter.unwrap()
            try presenter.editFooterView(with: remark.unwrap())
            self.indexPath = indexPath
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    func queryRiskArrange(with indexPath: IndexPath) -> String? {
        do {
            let item = self.arrangeList.item(at: indexPath.row)
            return try item.unwrap()
        } catch {
            return MolueLogger.UIModule.allowNil(error)
        }
    }
    
    func queryEditorCommand() -> PublishSubject<String> {
        let command: PublishSubject<String> = PublishSubject<String>()
        command.subscribe(onNext: { [unowned self] (arrange) in
            self.handleRiskArrange(with: arrange)
        }).disposed(by: self.disposeBag)
        return command
    }
    
    func queryCancelCommand() -> PublishSubject<Void> {
        let command: PublishSubject<Void> = PublishSubject<Void>()
        command.subscribe(onNext: { [unowned self] (_) in
            self.editorViewCancelCommand()
        }).disposed(by: self.disposeBag)
        return command
    }
    
    func editorViewCancelCommand() {
        do {
            let presenter = try self.presenter.unwrap()
            presenter.displayInsertFooterView()
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    func numberOfRows(at section: Int) -> Int? {
        return self.arrangeList.count
    }
    
    func querySubmitCommand() -> PublishSubject<Void> {
        let command: PublishSubject<Void> = PublishSubject<Void>()
        command.subscribe(onNext: { [unowned self] (_) in
            self.footerViewSubmitOperation()
        }).disposed(by: self.disposeBag)
        return command
    }
    
    func footerViewSubmitOperation() {
        do {
            let presenter = try self.presenter.unwrap()
            presenter.displayEditorFooterView()
            self.indexPath = nil
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    func handleRiskArrange(with arrange: String) {
        do {
            let presenter = try self.presenter.unwrap()
            presenter.displayInsertFooterView()
            if let indexPath = self.indexPath {
                self.arrangeList[indexPath.row] = arrange
            } else {
                self.arrangeList.append(arrange)
            }
            presenter.insertTableViewCell()
        } catch {
            MolueLogger.UIModule.error(error)
        }
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
            presenter.refreshFooterViewSelected(with: title)
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
