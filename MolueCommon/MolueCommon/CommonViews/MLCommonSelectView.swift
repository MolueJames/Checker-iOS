//
//  MLCommonSelectView.swift
//  MolueCommon
//
//  Created by James on 2018/6/3.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import UIKit
import RxSwift
import SnapKit
import MolueUtilities
public class MLCommonSelectView: UIView {
    public let clickedCommand = PublishSubject<Void>()
    lazy private var titleLabel: UILabel! = {
        let internalTitleLabel = UILabel()
        self.addSubview(internalTitleLabel)
        internalTitleLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(20)
            make.top.equalTo(8)
        })
        return internalTitleLabel
    }()
    lazy private var detailLabel: UILabel! = {
        let internalDetailLabel = UILabel()
        self.addSubview(internalDetailLabel)
        internalDetailLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(20)
            make.bottom.equalTo(-8)
        })
        return internalDetailLabel
    }()
    lazy private var rightImageView: UIImageView! = {
        let internalRightImageView = UIImageView()
        self.addSubview(internalRightImageView)
        internalRightImageView.snp.makeConstraints({ (make) in
            make.height.width.equalTo(40)
            make.centerY.equalToSuperview()
            make.right.equalTo(-5)
        })
        return internalRightImageView
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
    lazy private var clickedControl: UIControl! = {
        let internalClickedControl = UIControl()
        self.doBespreadOn(internalClickedControl)
        return internalClickedControl
    }()
    public override func awakeFromNib() {
        super.awakeFromNib()
        self.updateViewElements()
        self.clickedControl.addTarget(self, action: #selector(controlClicked), for: .touchUpInside)
    }
    private func updateViewElements() {
        self.detailLabel.textColor = MLCommonColor.detailText
        self.detailLabel.font = .systemFont(ofSize: 14)
        self.rightImageView.contentMode = .center
        self.lineView.backgroundColor = MLCommonColor.commonLine
        self.rightImageView.image = UIImage(named: "common_icon_right")
        self.titleLabel.textColor = MLCommonColor.titleLabel
        self.titleLabel.font = .systemFont(ofSize: 16)
    }
    @IBAction private func controlClicked(_ sender: Any) {
        self.clickedCommand.onNext(())
    }
    public func defaultValue(title: String, detail: String) {
        self.titleLabel.text = title
        self.detailLabel.text = detail
    }
    public func update(detail: String) {
        self.detailLabel.text = detail
    }
}
