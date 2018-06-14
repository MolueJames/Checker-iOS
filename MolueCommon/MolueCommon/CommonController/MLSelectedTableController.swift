//
//  MLSelectedTableController.swift
//  MolueCommon
//
//  Created by MolueJames on 2018/6/10.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import UIKit
import RxSwift
import MolueNavigator
import MolueFoundation
import MolueUtilities
public class MLSelectedTableController: MLBaseViewController, MolueNavigatorProtocol {
    public func doTransferParameters(params: Any?) {
        if let list = params as? [MLSelectedTableViewModel] {
            self.list = list
        }
    }
    
    public func doSettingParameters(params: Dictionary<String, String>) {
        if let title = params["title"] {
            self.title = title
        }
    }
    
    private var list = [MLSelectedTableViewModel]()
    
    public let selectRowCommand = PublishSubject<[Int]>()
    
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.allowsMultipleSelection = true
            tableView.register(xibWithCellClass: MLSelectedTableViewCell.self)
        }
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保持", style: .plain, target: self, action: #selector(saveButtonClicked))
        self.selectDefaultCells()
    }
    
    private func selectDefaultCells() {
        for (index , model) in list.enumerated() where model.selected {
            let indexPath = IndexPath.init(row: index, section: 0)
            self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        }
    }
    
    @IBAction private func saveButtonClicked(_ sender: UIBarButtonItem) {
        guard let selectedList = self.tableView.indexPathsForSelectedRows?.enumerated() else {
            MolueLogger.warning.message("the select list is not existed"); return
        }
        let list: [Int] = selectedList.compactMap { (_, element) -> Int in
            return element.row
            }.sorted {$0 < $1}
        self.selectRowCommand.onNext(list)
    }
    
    open override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension MLSelectedTableController: UITableViewDelegate {
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

extension MLSelectedTableController: UITableViewDataSource {
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MLSelectedTableViewCell! = tableView.dequeueReusableCell(withClass: MLSelectedTableViewCell.self)
        let value = self.list[indexPath.row]
        cell.reloadSubviewsWithValue(value)
        return cell
    }
}
