//
//  MLSelectedTableController.swift
//  MolueCommon
//
//  Created by MolueJames on 2018/6/10.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import MolueFoundation
import MolueUtilities

public protocol MLMutipleSectionProtocol: CustomStringConvertible {
    var selected: Bool {get set}
}

public class MLSelectedTableController<Target: MLMutipleSectionProtocol>: MLBaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    public let selectCommand = PublishSubject<[Target]>()
    
    private var list = [Target]()

    public func updateValues(title: String, list: [Target]) {
        self.title = title
        self.list = list
    }
    
    private var tableView: UITableView! {
        didSet {
            tableView.allowsMultipleSelection = true
            tableView.backgroundColor = .clear
            tableView.separatorStyle = .none
            tableView.register(xibWithCellClass: MLSelectedTableViewCell.self)
            tableView.delegate = self
            tableView.dataSource = self
        }
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "提交", style: .plain, target: self, action: #selector(saveButtonClicked))
        self.updateInterfaceConfigure()
        self.selectDefaultCells()
    }
    
    private func updateInterfaceConfigure() {
        self.tableView = UITableView()
        self.view.addSubview(tableView)
        self.tableView.snp.makeConstraints { [unowned self] (make) in
            make.top.equalTo(self.navigationView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
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
        let list: [Target] = selectedList.compactMap { [unowned self] (index, _) -> Target in
            var model = self.list[index]
            model.selected = true
            return model
        }
        self.selectCommand.onNext(list)
        self.navigationController?.popViewController(animated: true)
    }
    
    open override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
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
