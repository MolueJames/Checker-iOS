//
//  RiskArrangeFinishFooterView.swift
//  MolueRiskPart
//
//  Created by MolueJames on 2019/1/11.
//  Copyright © 2019 MolueTech. All rights reserved.
//

import MolueCommon
import RxSwift
import UIKit

class RiskArrangeFooterView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.masksToBounds = false
        let color = MLCommonColor.commonLine.cgColor
        self.layer.shadowColor = color
        self.layer.shadowOffset = CGSize(width: 0, height: -0.5)
        self.layer.shadowRadius = 0.5;
        self.layer.shadowOpacity = 0.7
    }
    
    private var submitCommand = PublishSubject<Void>()
    private var finishCommand = PublishSubject<Void>()
    
    @IBOutlet weak var budgetFromClickView: MLCommonClickView! {
        didSet {
            budgetFromClickView.defaultValue(title: "资金来源: ", placeholder: "请选择资金来源")
        }
    }
    
    @IBOutlet weak var budgetRiskInputView: MLCommonInputView! {
        didSet {
            budgetRiskInputView.defaultValue(title: "整改资金(元): ", placeholder: "请输入整改资金", keyboardType: .decimalPad)
        }
    }
    
    @IBAction func finishDateValueChanged(_ sender: UISwitch) {
        self.finishDateTextField.isHidden = !sender.isOn
    }
    
    @IBOutlet weak var finishDateTextField: UITextField! {
        didSet {
            finishDateTextField.delegate = self
        }
    }
    
    func updateFinishCommand(with command: PublishSubject<Void>) {
        self.finishCommand = command
    }
    
    func updateSubmitCommand(with command: PublishSubject<Void>) {
        self.submitCommand = command
    }
    
    func updateBudgetCommand(with command: PublishSubject<Void>) {
        self.budgetFromClickView.clickedCommand = command
    }
    
    func updateFinishDate(with title: String) {
        self.finishDateTextField.text = title
    }
    
    func updateBudgetFrom(with title: String) {
        self.budgetFromClickView.update(description: title)
    }
    
    @IBAction func submitButtonClicked(_ sender: UIButton) {
        self.submitCommand.onNext(())
    }
}

extension RiskArrangeFooterView: UITextFieldDelegate {
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.finishCommand.onNext(())
        return false
    }
}
