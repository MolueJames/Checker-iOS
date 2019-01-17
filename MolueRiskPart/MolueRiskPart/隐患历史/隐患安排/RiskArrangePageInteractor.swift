//
//  RiskArrangePageInteractor.swift
//  MolueRiskPart
//
//  Created by JamesCheng on 2019-01-07.
//  Copyright © 2019 MolueTech. All rights reserved.
//

import MolueUtilities
import MolueMediator
import MolueCommon
import RxSwift

protocol RiskArrangeViewableRouting: class {
    // 定义一些页面跳转的方法, 比如Push, Presenter等.
    func presentDatePicker(with command: PublishSubject<(date: Date, string: String)>)
    
}

protocol RiskArrangePagePresentable: MolueInteractorPresentable {
    var listener: RiskArrangePresentableListener? { get set }
    // 定义一些页面需要的方法, 比如刷新页面的显示内容等.
    func refreshFooterViewSelected(with title: String)
    
    func reloadTableViewCell()
    
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
    func deleteEditedArrange(at indexPath: IndexPath) {
        self.arrangeList.remove(at: indexPath.row)
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
            presenter.reloadTableViewCell()
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
