//
//  NoHiddenRiskReusableFooterView.swift
//  MolueRiskPart
//
//  Created by JamesCheng on 2018-11-22.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import UIKit
import RxSwift
import MolueCommon

class NoHiddenRiskReusableFooterView: UICollectionReusableView {
    private let disposeBag = DisposeBag()
    
    public var submitInfoCommand: PublishSubject<String>?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBOutlet weak var reasonRemarkView: MLCommonRemarkView! {
        didSet {
            reasonRemarkView.defaultValue(title: "请填写具体该次检查的详情", limit: 100)
        }
    }
    
    public func refreshSubviews(with text: String) {
        self.submitInfoCommand = PublishSubject<String>()
        self.reasonRemarkView.updateRemark(with: text)
    }
    
    @IBAction func submitButtonClicked(_ sender: UIButton) {
        let text = self.reasonRemarkView.remarkText()
        self.submitInfoCommand?.onNext(text)
    }
    
}
