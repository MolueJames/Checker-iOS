//
//  RiskArrangeViewController.swift
//  MolueRiskPart
//
//  Created by JamesCheng on 2019-01-07.
//  Copyright © 2019 MolueTech. All rights reserved.
//

import MolueMediator
import MolueFoundation
import MolueUtilities
import RxSwift
import UIKit

protocol RiskArrangePresentableListener: class {
    // 定义一些当前页面需要的业务逻辑, 比如网络请求.
    func numberOfRows(at section: Int) -> Int?
    
    func queryHiddenPeril() -> MLHiddenPerilItem?
    
    func queryEditorCommand() -> PublishSubject<String>
    
    func querySubmitCommand() -> PublishSubject<Void>
    
    func queryFinishCommand() -> PublishSubject<Void>
    
    func queryCancelCommand() -> PublishSubject<Void>
    
    func queryRiskArrange(with indexPath: IndexPath) -> String?
    
    func editPreviousArrange(at indexPath: IndexPath)
    
    func deleteEditedArrange(at indexPath: IndexPath)
}

final class RiskArrangeViewController: MLBaseViewController  {
    //MARK: View Controller Properties
    var listener: RiskArrangePresentableListener?
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(xibWithCellClass: RiskArrangeTableViewCell.self)
            tableView.tableHeaderView = self.headerView
        }
    }
    
    lazy var footerView: RiskArrangeFooterView = {
        let footerView: RiskArrangeFooterView = RiskArrangeFooterView.createFromXib()
        let width: CGFloat = MLConfigure.ScreenWidth
        self.view.addSubview(footerView)
        footerView.snp.makeConstraints({ (maker) in
            if #available(iOS 11.0, *) {
                let layout = self.view.safeAreaLayoutGuide
                let bottom = layout.snp.bottom
                maker.bottom.equalTo(bottom)
            } else {
                maker.bottom.equalToSuperview()
            }
            maker.left.right.equalToSuperview()
            maker.height.equalTo(100)
        })
        self.setupFooterViewConfiguration(with: footerView)
        return footerView
    }()
    
    lazy var editorView: ArrangeEditFooterView = {
        let editorView: ArrangeEditFooterView = ArrangeEditFooterView.createFromXib()
        self.view.addSubview(editorView)
        editorView.snp.makeConstraints({ (maker) in
            if #available(iOS 11.0, *) {
                let layout = self.view.safeAreaLayoutGuide
                let bottom = layout.snp.bottom
                maker.bottom.equalTo(bottom)
            } else {
                maker.bottom.equalToSuperview()
            }
            maker.left.right.equalToSuperview()
            maker.top.equalToSuperview()
        })
        self.setupEditorViewConfiguration(with: editorView)
        return editorView
    }()
    
    lazy var headerView: RiskArrangeHeaderView = {
        let headerView: RiskArrangeHeaderView = RiskArrangeHeaderView.createFromXib()
        let width: CGFloat = MLConfigure.ScreenWidth
        headerView.frame = CGRect(x: 0, y: 0, width: width, height: 400)
        self.setupHeaderViewConfiguration(with: headerView)
        return headerView
    }()
    
    func setupFooterViewConfiguration(with footerView: RiskArrangeFooterView) {
        do {
            let listener = try self.listener.unwrap()
            footerView.submitCommand = listener.querySubmitCommand()
            let finishCommand = listener.queryFinishCommand()
            footerView.updateFinishCommand(with: finishCommand)
        } catch {MolueLogger.UIModule.error(error)}
    }
    
    func setupHeaderViewConfiguration(with headerView: RiskArrangeHeaderView) {
        do {
            let listener = try self.listener.unwrap()
            let item = try listener.queryHiddenPeril().unwrap()
            headerView.refreshSubviews(with: item)
        } catch { MolueLogger.UIModule.error(error) }
    }
    
    func setupEditorViewConfiguration(with editorView: ArrangeEditFooterView) {
        do {
            let listener = try self.listener.unwrap()
            editorView.submitCommand = listener.queryEditorCommand()
            editorView.cancelCommand = listener.queryCancelCommand()
        } catch { MolueLogger.UIModule.error(error) }
    }
    
    lazy var rightItem: UIBarButtonItem = {
        return UIBarButtonItem(title: "提交", style: .done, target: self, action: #selector(rightItemClicked))
    }()
    
    //MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension RiskArrangeViewController: MLUserInterfaceProtocol {
    func queryInformationWithNetwork() {
        
    }
    
    func updateUserInterfaceElements() {
        self.navigationItem.rightBarButtonItem = self.rightItem
        self.footerView.isHidden = false
        self.editorView.isHidden = true
        self.updateHeaderViewLayout()
        self.title = "隐患安排"
    }
    
    func updateHeaderViewLayout() {
        self.headerView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
        self.tableView.layoutIfNeeded()
        self.tableView.tableHeaderView = self.headerView
    }
    
    @IBAction func rightItemClicked(_ sender: UIBarButtonItem) {
    }
}

extension RiskArrangeViewController: RiskArrangePagePresentable {
    func editFooterView(with text: String) {
        self.editorView.updateRemarkText(with: text)
        self.displayEditorFooterView()
    }
    
    func displayEditorFooterView() {
        self.editorView.becomeFirstResponder()
        self.editorView.isHidden = false
        self.footerView.isHidden = true
    }
    
    func displayInsertFooterView() {
        self.footerView.isHidden = false
        self.editorView.isHidden = true
    }
    
    func reloadTableViewCell() {
        do {
            self.tableView.reloadData()
            let indexPath = try self.tableView.indexPathForLastRow.unwrap()
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        } catch { MolueLogger.UIModule.message(error) }
    }
    
    func refreshFooterViewSelected(with title: String) {
        self.footerView.updateFinishDate(with: title)
    }
}

extension RiskArrangeViewController: RiskArrangeViewControllable {
    
}

extension RiskArrangeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        do {
            let listener = try self.listener.unwrap()
            let count = listener.numberOfRows(at: section)
            return try count.unwrap()
        } catch { return 0 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: RiskArrangeTableViewCell.self)
        do {
            let listener = try self.listener.unwrap()
            let item = listener.queryRiskArrange(with: indexPath)
            try cell.refreshSubviews(with: item.unwrap())
        } catch { MolueLogger.UIModule.error(error) }
        return cell
    }
    
}

extension RiskArrangeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        do {
            let listener = try self.listener.unwrap()
            listener.editPreviousArrange(at: indexPath)
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        do {
            let listener = try self.listener.unwrap()
            listener.deleteEditedArrange(at: indexPath)
            self.tableView.deleteRows(at: [indexPath], with: .right)
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
}
