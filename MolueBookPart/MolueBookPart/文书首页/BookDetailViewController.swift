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

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(xibWithCellClass: BookInfoTableViewCell.self)
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
    
}

extension BookDetailViewController: MLUserInterfaceProtocol {
    func queryInformationWithNetwork() {
        
    }
    
    func updateUserInterfaceElements() {

    }
}

extension BookDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
extension BookDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: BookInfoTableViewCell.self)
        return cell
    }
}
