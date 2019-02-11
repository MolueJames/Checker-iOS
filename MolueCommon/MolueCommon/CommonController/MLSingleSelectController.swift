//
//  MLSingleSectionController.swift
//  MolueCommon
//
//  Created by MolueJames on 2018/6/16.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import MolueFoundation
import MolueUtilities

public typealias MLSingleSelectProtocol = CustomStringConvertible

public class MLSingleSelectController<Target: MLSingleSelectProtocol>: MLBaseViewController, UITableViewDelegate, UITableViewDataSource {
  
    private var list = [Target]()
    
    private var selectCommand = PublishSubject<Target>()
    
    public func updateSelectCommand(with command: PublishSubject<Target>) {
        self.selectCommand = command
    }
    
    private var tableView: UITableView! {
        didSet {
            tableView.backgroundColor = .clear
            tableView.separatorStyle = .none
            tableView.register(xibWithCellClass: MLSignleSelectTableCell.self)
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    public func updateValues(title: String, list: [Target]) {
        self.title = title
        self.list = list
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "提交", style: .plain, target: self, action: #selector(saveButtonClicked))
        self.updateInterfaceConfigure()
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
    @IBAction private func saveButtonClicked(_ sender: UIBarButtonItem) {
        do {
            let selectIndex = try self.tableView.indexPathForSelectedRow.unwrap()
            let model = self.list[selectIndex.row]
            self.selectCommand.onNext(model)
            self.navigationController?.popViewController(animated: true)
        } catch {
            MolueLogger.warning.message(error)
        }
    }
    open override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MLSignleSelectTableCell! = tableView.dequeueReusableCell(withClass: MLSignleSelectTableCell.self)
        let value = self.list[indexPath.row]
        cell.reloadSubviewsWithValue(value)
        return cell
    }
}
