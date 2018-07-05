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
import MolueUtilities
class BookInfoSectionView: UIView {
    enum BookInfoSelected: Int {
        case left = 0
        case right = 1
    }
    lazy private var enforceButton: UIButton! = {
        let internalEnforceButton = UIButton()
        self.addSubview(internalEnforceButton)
        internalEnforceButton.snp.makeConstraints({ (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
        })
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
        bottomView.addSubview(internalLineView)
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
    
    public let selectedCommand = PublishSubject<Int>()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addtionButton.addTarget(self, action: #selector(addtionButtonClicked), for: .touchUpInside)
        self.enforceButton.addTarget(self, action: #selector(enforceButtonClicked), for: .touchUpInside)
        self.updateViewElements()
    }
    private func updateViewElements() {
        self.bottomView.backgroundColor = MLCommonColor.commonLine
        self.lineView.backgroundColor = MLCommonColor.appDefault
        self.updateButtonConfigure(self.addtionButton, title: "其他")
        self.updateButtonConfigure(self.enforceButton, title: "执法")
    }
    
    @IBAction private func addtionButtonClicked(_ sender: UIButton) {
        if sender.isSelected == false {
            let index = BookInfoSelected.right.rawValue
            self.setSelectedIndex(index, animated: true)
            self.selectedCommand.onNext(index)
        }
    }
    @IBAction private func enforceButtonClicked(_ sender: UIButton) {
        if sender.isSelected == false {
            let index = BookInfoSelected.left.rawValue
            self.setSelectedIndex(index, animated: true)
            self.selectedCommand.onNext(index)
        }
    }
    private func selectedIndexButton(_ index: Int, animated: Bool) {
        let leftDistance = index == 0 ? 0 : MLConfigure.ScreenWidth/2
        self.lineView.snp.updateConstraints { (make) in
            make.left.equalTo(leftDistance)
        }
        if animated { self.doSelectedIndexAnimated() }
    }
    private func doSelectedIndexAnimated() {
        UIView.animate(withDuration: 0.1) {
            self.layoutIfNeeded()
        }
    }
    public func setSelectedIndex(_ index: Int, animated: Bool) {
        let isLeft = index == 0
        self.enforceButton.isSelected = isLeft
        self.addtionButton.isSelected = !isLeft
        self.selectedIndexButton(index, animated: animated)
    }
    
}
