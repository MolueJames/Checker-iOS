//
//  ArrangeEditFooterView.swift
//  MolueRiskPart
//
//  Created by MolueJames on 2019/1/17.
//  Copyright © 2019 MolueTech. All rights reserved.
//

import MolueCommon
import RxSwift
import UIKit

class ArrangeEditFooterView: UIView {

    @IBOutlet weak var remarkView: MLCommonRemarkView! {
        didSet {
            remarkView.defaultValue(title: "请添加隐患整改步骤", limit: 150)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.cancelControl.addTarget(self, action: #selector(cancelControlClicked), for: .touchUpInside)
    }
    
    lazy var cancelControl: UIControl = {
        let control = UIControl()
        self.insertSubview(control, at: 0)
        control.snp.makeConstraints({ (maker) in
            maker.left.right.equalToSuperview()
            maker.top.bottom.equalToSuperview()
        })
        return control
    }()
    
    @IBAction func cancelControlClicked(_ sender: UIControl) {
        if self.remarkView.remarkText().isEmpty {
            self.cancelCommand.onNext(())
        }
        self.remarkView.resignFirstResponder()
    }
    
    public var submitCommand = PublishSubject<String>()
    
    public var cancelCommand = PublishSubject<Void>()
    
    @IBAction func cancelButtonClicked(_ sender: UIButton) {
        self.cancelCommand.onNext(())
    }
    
    @discardableResult
    override func becomeFirstResponder() -> Bool {
        return self.remarkView.becomeFirstResponder()
    }
    
    @IBAction func submitButtonClicked(_ sender: UIButton) {
        self.submitCommand.onNext(self.remarkView.remarkText())
        self.remarkView.updateRemark(with: "")
    }
    
    func updateRemarkText(with text: String) {
        self.remarkView.updateRemark(with: text)
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
