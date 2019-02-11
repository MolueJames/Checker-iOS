//
//  EditSituationViewController.swift
//  MolueRiskPart
//
//  Created by MolueJames on 2019/1/28.
//  Copyright © 2019 MolueTech. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import MolueUtilities
import MolueFoundation
import MolueMediator
import MolueCommon

public protocol EditSituationProtocol: class {
    func insert(with situation: MLPerilSituation)
    func update(with situation: MLPerilSituation)
}

class EditSituationViewController: MLBaseViewController {
    
    public var situation: MLPerilSituation?
    
    @IBOutlet weak var remarkView: MLCommonRemarkView! {
        didSet {
            remarkView.defaultValue(title: "请填写隐患问题描述", limit: 100)
        }
    }
    
    @IBOutlet weak var contentView: UIView! {
        didSet {
            contentView.layer.masksToBounds = true
            contentView.layer.cornerRadius = 4
        }
    }
    
    @IBAction func cancelButtonClicked(_ sender: UIButton) {
        self.remarkView.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitButtonClicked(_ sender: UIButton) {
        let text = self.remarkView.remarkText()
        if text.isEmpty == false {
            let situation = MLPerilSituation(text)
            let insert: Bool = self.situation.isNone()
            self.insertOrUpdate(with: situation, insert: insert)
            self.remarkView.resignFirstResponder()
            self.dismiss(animated: true, completion: nil)
        } else {
            self.showWarningHUD(text: "请填写隐患问题描述")
        }
    }
    
    func insertOrUpdate(with situation: MLPerilSituation, insert: Bool) {
        do {
            let delegate = try self.delegate.unwrap()
            insert ? delegate.insert(with: situation) : delegate.update(with: situation)
        } catch {
            MolueLogger.UIModule.message(error)
        }
    }
    
    weak var delegate: EditSituationProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        do {
            let situation = try self.situation.unwrap()
            let content = try situation.content.unwrap()
            self.remarkView.updateRemark(with: content)
        } catch {MolueLogger.UIModule.message(error)}
        
        self.remarkView.becomeFirstResponder()
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 55.0
        let color = UIColor.black.withAlphaComponent(0.3)
        self.view.backgroundColor = color
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
