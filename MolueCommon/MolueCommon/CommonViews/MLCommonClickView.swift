//
//  MLCommonClickView.swift
//  MolueCommon
//
//  Created by James on 2018/6/4.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import UIKit
import RxSwift
import MolueUtilities
public class MLCommonClickView: UIView {
    lazy private var titleLabel: UILabel! = {
        let internalTitleLabel = UILabel()
        self.addSubview(internalTitleLabel)
        internalTitleLabel.snp.makeConstraints({ (make) in
            make.centerY.equalToSuperview()
            make.width.equalTo(85)
            make.left.equalTo(20)
        })
        return internalTitleLabel
    }()
    
    lazy private var textField: UITextField! = {
        let internalTextField = UITextField()
        self.addSubview(internalTextField)
        internalTextField.snp.makeConstraints { (make) in
            make.bottom.top.equalToSuperview()
            make.left.equalTo(95)
            make.right.equalTo(-15)
        }
        return internalTextField
    }()
    lazy private var lineView: UIView! = {
        let lineView = UIView()
        self.addSubview(lineView)
        lineView.snp.makeConstraints({ (make) in
            make.left.equalTo(20)
            make.bottom.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(MLConfigure.singleLineHeight)
        })
        return lineView
    }()
    
    public var clickedCommand = PublishSubject<Void>()

    public override func awakeFromNib() {
        super.awakeFromNib()
        self.updateViewElements()
    }
    
    private func updateViewElements() {
        self.lineView.backgroundColor = MLCommonColor.commonLine
        self.titleLabel.font = .systemFont(ofSize: 15)
        self.titleLabel.textColor = MLCommonColor.titleLabel
        self.textField.delegate = self
        self.textField.font = .systemFont(ofSize: 15)
        self.textField.textColor = MLCommonColor.titleLabel
        self.textField.textAlignment = .right
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
