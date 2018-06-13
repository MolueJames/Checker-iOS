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
public class MLSelectedTableController: MLBaseViewController, MolueNavigatorProtocol {
    public func doTransferParameters(params: Any?) {
        if let list = params as? [[String : String]] {
            self.list = list
        }
    }
    
    public func doSettingParameters(params: Dictionary<String, String>) {
        
    }
    
    private var list = [[String : String]]()
    private var isMutiple = false
    
    public let selectRowCommand = PublishSubject<Int>()
    
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(xibWithCellClass: MLSelectedTableViewCell.self)
        }
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    open override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
}

extension MLSelectedTableController: UITableViewDelegate {

}

extension MLSelectedTableController: UITableViewDataSource {
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MLSelectedTableViewCell! = tableView.dequeueReusableCell(withClass: MLSelectedTableViewCell.self)
        return cell
    }
}
