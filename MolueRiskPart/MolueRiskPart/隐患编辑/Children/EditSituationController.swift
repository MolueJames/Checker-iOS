//
//  EditSituationViewController.swift
//  MolueRiskPart
//
//  Created by MolueJames on 2019/1/28.
//  Copyright © 2019 MolueTech. All rights reserved.
//

import UIKit
import MolueUtilities
import MolueFoundation
import MolueMediator
import MolueCommon

public protocol EditSituationProtocol: class {
    func insert(with situation: MLHiddenPerilSituation)
    func update(with situation: MLHiddenPerilSituation)
}

class EditSituationViewController: MLBaseViewController {
    
    public var situation: MLHiddenPerilSituation?
    
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
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitButtonClicked(_ sender: UIButton) {
        let text = self.remarkView.remarkText()
        let situation = MLHiddenPerilSituation(text)
        let insert: Bool = self.situation.isNone()
        self.insertOrUpdate(with: situation, insert: insert)
        self.dismiss(animated: true, completion: nil)
    }
    
    func insertOrUpdate(with situation: MLHiddenPerilSituation, insert: Bool) {
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
        let color = UIColor.black.withAlphaComponent(0.3)
        self.view.backgroundColor = color
        do {
            let situation = try self.situation.unwrap()
            let content = try situation.content.unwrap()
            self.remarkView.updateRemark(with: content)
        } catch {
            MolueLogger.UIModule.message(error)
        }
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
