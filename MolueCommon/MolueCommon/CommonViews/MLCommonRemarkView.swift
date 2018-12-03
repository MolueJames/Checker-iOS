
//
//  MLCommonRemarkView.swift
//  MolueCommon
//
//  Created by MolueJames on 2018/7/8.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import UIKit
import SnapKit
import MolueUtilities
public class MLCommonRemarkView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.updateViewElements()
    }
    
    private func updateViewElements() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        let attributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key.paragraphStyle : paragraphStyle]
        self.remarkTextView.typingAttributes = attributes
        self.remarkTextView.font = .systemFont(ofSize: 15)
        self.remarkTextView.textColor = MLCommonColor.titleLabel
        self.lineView.backgroundColor = MLCommonColor.commonLine
        self.placeholderLable.textColor = UIColor.lightGray
        self.placeholderLable.font = .systemFont(ofSize: 15)
        self.numberLabel.font = .systemFont(ofSize: 13)
        self.numberLabel.textColor = MLCommonColor.commonLine
    }
    
    private var textLimit: Int = 0
    
    lazy private var placeholderLable: UILabel! = {
        let placeholderLable = UILabel()
        self.addSubview(placeholderLable)
        placeholderLable.snp.makeConstraints({ (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(25)
            make.top.equalTo(10)
        })
        return placeholderLable
    }()
    
    lazy private var remarkTextView: UITextView! = {
        let remarkTextView = UITextView()
        remarkTextView.delegate = self
        self.insertSubview(remarkTextView, at: 0)
        remarkTextView.snp.makeConstraints({ (make) in
            make.right.equalTo(-17)
            make.left.equalTo(17)
            make.top.equalTo(6)
            make.bottom.equalTo(-15)
        })
        return remarkTextView
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
    
    lazy private var numberLabel: UILabel! = {
        let numberLabel = UILabel()
        self.addSubview(numberLabel)
        numberLabel.snp.makeConstraints({ (make) in
            make.right.equalTo(-15)
            make.bottom.equalTo(-10)
        })
        return numberLabel
    }()
    
    public func defaultValue(title: String, limit: Int) {
        self.placeholderLable.text = title
        self.numberLabel.text = "0/\(limit)"
        self.textLimit = limit
    }
    
    public func remarkText() -> String {
        return self.remarkTextView.text
    }
}

extension MLCommonRemarkView: UITextViewDelegate {
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        self.placeholderLable.isHidden = true
        return true
    }

    public func textViewDidEndEditing(_ textView: UITextView) {
        self.placeholderLable.isHidden = textView.text.count != 0
    }
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        do {
            let currentText: NSString = try textView.text.toTarget()
            let targetText = currentText.replacingCharacters(in: range, with: text)
            self.placeholderLable.isHidden = targetText.count > 0
            let count = targetText.count > 100 ? 100 : targetText.count
            self.numberLabel.text = "\(count)/\(self.textLimit)"
        } catch {
            MolueLogger.UIModule.error(error)
        }
        return textView.text.count + (text.count - range.length) <= self.textLimit
    }
}
