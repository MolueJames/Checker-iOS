//
//  MLCommonInputView.swift
//  MolueCommon
//
//  Created by James on 2018/6/3.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import UIKit
import RxSwift
public class MLCommonInputView: UIView {
    @IBOutlet private weak var textFiled: UITextField! {
        didSet {
            textFiled.addTarget(self, action: #selector(textValueChanged), for: .editingChanged)
        }
    }
    @IBOutlet private weak var titleLabel: UILabel!
    
    public let textChangedCommand = PublishSubject<String>()
    
    @IBAction private func textValueChanged(_ textFiled: UITextField) {
        guard let text = textFiled.text else {return}
        self.textChangedCommand.onNext(text)
    }
    
    public func defaultValue(title: String, placeholder: String, keyboardType: UIKeyboardType = .default) {
        self.titleLabel.text = title
        self.textFiled.placeholder = placeholder
        self.textFiled.keyboardType = keyboardType
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
}


