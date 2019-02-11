//
//  MLCommonInputView.swift
//  MolueCommon
//
//  Created by James on 2018/6/3.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import UIKit
import RxSwift
import SnapKit
import MolueUtilities
public class MLCommonInputView: UIView {
    lazy private var textFiled: UITextField! = {
        let internalTextField = UITextField()
        self.addSubview(internalTextField)
        internalTextField.snp.makeConstraints({ (make) in
            make.right.equalTo(-15)
            make.left.equalTo(120)
            make.top.bottom.equalToSuperview()
        })
        return internalTextField
    }()
    lazy private var titleLabel: UILabel! = {
        let internalTitleLabel = UILabel()
        self.addSubview(internalTitleLabel)
        internalTitleLabel.snp.makeConstraints({ (make) in
            make.width.equalTo(100)
            make.left.equalTo(20)
            make.top.bottom.equalToSuperview()
        })
        return internalTitleLabel
    }()
    
    lazy private var lineView: UIView! = {
        let internalLineView = UIView()
        self.addSubview(internalLineView)
        internalLineView.snp.makeConstraints({ (make) in
            make.left.equalTo(20)
            make.bottom.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(MLConfigure.singleLineHeight)
        })
        return internalLineView
    }()
    
    public let textChangedCommand = PublishSubject<String>()
    
    @IBAction private func textValueChanged(_ textFiled: UITextField) {
        do {
            let text = try textFiled.text.unwrap()
            self.textChangedCommand.onNext(text)
        } catch {
            MolueLogger.UIModule.message(error)
        }
    }
    
    public func defaultValue(title: String, placeholder: String, keyboardType: UIKeyboardType = .default) {
        self.titleLabel.text = title
        self.textFiled.placeholder = placeholder
        self.textFiled.keyboardType = keyboardType
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        self.textFiled.addTarget(self, action: #selector(textValueChanged), for: .editingChanged)
        self.updateViewElements()
    }
    
    private func updateViewElements() {
        self.lineView.backgroundColor = MLCommonColor.commonLine
        self.textFiled.font = .systemFont(ofSize: 15)
        self.textFiled.textColor = MLCommonColor.titleLabel
        self.textFiled.textAlignment = .right
        self.titleLabel.font = .systemFont(ofSize: 15)
        self.titleLabel.textColor = MLCommonColor.titleLabel
    }
}


