//
//  ForgetPasswordViewController.swift
//  MolueLoginPart
//
//  Created by MolueJames on 2018/10/14.
//  Copyright © 2018 MolueJames. All rights reserved.
//

import UIKit
import MolueFoundation

protocol ForgetPasswordPresentableListener: class {
    // 定义一些当前页面需要的业务逻辑, 比如网络请求.
    func bindingTableViewAdapter(with tableView: UITableView)
    func addToTableView(item: String)
}

final class ForgetPasswordViewController: MLBaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var listener: ForgetPasswordPresentableListener?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension ForgetPasswordViewController: MLUserInterfaceProtocol {
    func queryInformationWithNetwork() {
        
    }
    
    func updateUserInterfaceElements() {
        do {
            let listener = try self.listener.unwrap()
            listener.bindingTableViewAdapter(with: self.tableView)
        } catch {
            
        }
        let item = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(rightItemClicked))
        self.navigationItem.rightBarButtonItem = item
    }
    
    @IBAction func rightItemClicked(_ Item: UIBarButtonItem) {
        do {
            let listener = try self.listener.unwrap()
            listener.addToTableView(item: "5")
        } catch {
            
        }
    }
}

extension ForgetPasswordViewController: ForgetPasswordPagePresentable {
    
    
}

extension ForgetPasswordViewController: ForgetPasswordViewControllable {
    
    
    
}
