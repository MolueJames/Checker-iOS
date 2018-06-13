//
//  MLCommonClickView.swift
//  MolueCommon
//
//  Created by James on 2018/6/4.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import UIKit
import RxSwift
public class MLCommonClickView: UIView {

    @IBOutlet private weak var titleLabel: UILabel!
    
    @IBOutlet private weak var textField: UITextField! {
        didSet {
            textField.delegate = self
        }
    }
    public let clickedCommand = PublishSubject<Void>()
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    public override func awakeFromNib() {
        super.awakeFromNib()
//        clickedControl.addTarget(self, action: #selector(controlClicked), for: .touchUpInside)
    }

    lazy private var clickedControl: UIControl! = {
        let clickedControl = UIControl()
        self.doBespreadOn(clickedControl)
        return clickedControl
    }()
    
    @IBAction private func controlClicked(_ sender: UIControl) {
        self.clickedCommand.onNext(())
    }
    
    private func textFieldBeginEditing() {
        self.clickedCommand.onNext(())
    }
    
    public func defaultValue(title: String, placeholder: String) {
        self.titleLabel.text = title
        self.textField.placeholder = placeholder
    }
    
    public func update(description: String) {
        self.textField.text = description
    }
}

extension MLCommonClickView: UITextFieldDelegate {
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.textFieldBeginEditing()
        return false
    }
}
