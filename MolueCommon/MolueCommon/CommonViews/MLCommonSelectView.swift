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
public class MLCommonSelectView: UIView {
    public let clickedCommand = PublishSubject<Void>()
    @IBOutlet public weak var titleLabel: UILabel!
    @IBOutlet public weak var descriptionLabel: UILabel!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    lazy private var clickedControl: UIControl! = {
        let clickedControl = UIControl()
        self.addSubview(clickedControl)
        clickedControl.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        return clickedControl
    }()
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        clickedControl.addTarget(self, action: #selector(controlClicked), for: .touchUpInside)
    }
    
    @IBAction private func controlClicked(_ sender: Any) {
        self.clickedCommand.onNext(())
    }
}
