//
//  BookInfoSectionView.swift
//  MolueBookPart
//
//  Created by MolueJames on 2018/7/4.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import UIKit
import RxSwift
import SnapKit
import MolueCommon
class BookInfoSectionView: UIView {
    lazy private var enforceButton: UIButton! = {
        let internalEnforceButton = UIButton()
        self.addSubview(internalEnforceButton)
        internalEnforceButton.snp.makeConstraints({ (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
        })
        self.updateButtonConfigure(internalEnforceButton, title: "执法")
        return internalEnforceButton
    }()
    lazy private var addtionButton: UIButton! = {
        let internalAddtionButton = UIButton()
        self.addSubview(internalAddtionButton)
        internalAddtionButton.snp.makeConstraints({ (make) in
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
        })
        self.updateButtonConfigure(internalAddtionButton, title: "其他")
        return internalAddtionButton
    }()
    
    private func updateButtonConfigure(_ button: UIButton, title: String) {
        button.setTitleColor(MLCommonColor.appDefault, for: .selected)
        button.setTitleColor(MLCommonColor.detailText, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.setTitle(title, for: .normal)
    }
    lazy private var lineView: UIView! = {
        let internalLineView = UIView()
        self.addSubview(internalLineView)
        internalLineView.snp.updateConstraints({ [unowned self] (make) in
            make.left.equalTo(0)
        })
        internalLineView.snp.makeConstraints({ (make) in
            make.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(1)
        })
        return internalLineView
    }()
    lazy private var bottomView: UIView! = {
        let internalBottomView = UIView()
        self.addSubview(internalBottomView)
        internalBottomView.snp.makeConstraints({ (make) in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
        })
        return internalBottomView
    }()
    
    public let enforceCommand = PublishSubject<Void>()
    public let addtionCommand = PublishSubject<Void>()
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addtionButton.addTarget(self, action: #selector(addtionButtonClicked), for: .touchUpInside)
        self.enforceButton.addTarget(self, action: #selector(enforceButtonClicked), for: .touchUpInside)
        self.bottomView.backgroundColor = MLCommonColor.commonLine
        self.lineView.backgroundColor = MLCommonColor.appDefault
    }
    
    @IBAction private func addtionButtonClicked(_ sender: UIButton) {
        if sender.isSelected == false {
            sender.isSelected = true
            self.enforceButton.isSelected = false
            self.updateLineView(false)
        }
    }
    @IBAction private func enforceButtonClicked(_ sender: UIButton) {
        if sender.isSelected == false {
            sender.isSelected = true
            self.addtionButton.isSelected = false
            self.updateLineView(true)
        }
    }
    private func updateLineView(_ isDefault: Bool) {
        self.lineView.snp.updateConstraints { (make) in
            make.left.equalTo(isDefault ? 0 : 200)
        }
        UIView.animate(withDuration: 0.4) {
            self.layoutIfNeeded()
        }
    }
}
