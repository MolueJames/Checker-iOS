//
//  BookDetailViewController.swift
//  MolueBookPart
//
//  Created by MolueJames on 2018/7/5.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import UIKit
import MolueFoundation
import MolueUtilities
class BookDetailViewController: MLBaseViewController {
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    lazy private var tableView: UITableView! = {
        let internalTableView = UITableView()
        self.view.doBespreadOn(internalTableView)
        internalTableView.delegate = self
        internalTableView.register(xibWithCellClass: BookInfoTableViewCell.self)
        internalTableView.dataSource = self
        return internalTableView
    }()
}

extension BookDetailViewController: MLUserInterfaceProtocol {
    func queryInformationWithNetwork() {
        
    }
    
    func updateUserInterfaceElements() {
        self.tableView.backgroundColor = .clear
        self.tableView.separatorStyle = .none
//        self.updateNavigationView(height: 0)
        MolueLogger.UIModule.message(self.parent)
    }
}

extension BookDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
extension BookDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: BookInfoTableViewCell.self)!
        return cell
    }
}
