//
//  PotentialRiskViewController.swift
//  MolueRiskPart
//
//  Created by MolueJames on 2018/10/31.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import UIKit
import MolueFoundation
import MolueUtilities
import MolueCommon
import MolueMediator

protocol PotentialRiskPresentableListener: class {
    // 定义一些当前页面需要的业务逻辑, 比如网络请求.
//    func bindingTableViewAdapter(with tableView: UITableView)
    var valueList: [PotentialRiskModel] {get}
    func jumpToRiskDetailController(with index: Int)
}

final class PotentialRiskViewController: MLBaseViewController  {
    //MARK: View Controller Properties
    var listener: PotentialRiskPresentableListener?
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(xibWithCellClass: PotentialRiskTableViewCell.self)
        }
    }
    
    @IBOutlet weak var segementView: MLCommonSegementView! {
        didSet {
            segementView.delegate = self
            let list = ["已发现", "已安排", "已整改", "已验收"]
            segementView.updateSegementList(with: list)
        }
    }
    
    //MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension PotentialRiskViewController: MLUserInterfaceProtocol {
    func queryInformationWithNetwork() {
        
    }
    
    func updateUserInterfaceElements() {
        self.title = "隐患历史"
    }
}

extension PotentialRiskViewController: PotentialRiskPagePresentable {
    
}

extension PotentialRiskViewController: PotentialRiskViewControllable {
    
}

extension PotentialRiskViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        do {
            let listener = try self.listener.unwrap()
            listener.jumpToRiskDetailController(with: indexPath.row)
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 142
    }
}

extension PotentialRiskViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        do {
            let listener = try self.listener.unwrap()
            return listener.valueList.count
        } catch {return 0}
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: PotentialRiskTableViewCell.self)
        do {
            let listener = try self.listener.unwrap()
            let item = try listener.valueList.item(at: indexPath.row).unwrap()
            cell.refreshSubviews(with: item, index: indexPath.row)
        } catch { MolueLogger.UIModule.error(error) }
        return cell
    }
}

extension PotentialRiskViewController: MLSegementViewDelegate {
    func segementView(_ segementView: MLCommonSegementView, didSelectItemAt index: Int) {
        
    }
}
