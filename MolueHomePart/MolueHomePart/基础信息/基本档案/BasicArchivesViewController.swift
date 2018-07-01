//
//  BasicArchivesViewController.swift
//  MolueMinePart
//
//  Created by James on 2018/6/1.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import UIKit
import RxSwift
import MolueFoundation
import MolueCommon
class BasicArchivesViewController: MLBaseViewController {
    let disposeBag = DisposeBag()

    @IBOutlet weak var codeInputView: MLCommonInputView! {
        didSet {
            codeInputView.defaultValue(title: "信用代码", placeholder: "请输入18位统一社会信用代码", keyboardType: .numberPad)
        }
    }

    @IBOutlet weak var divisionSelectView: MLCommonSelectView! {
        didSet {
            divisionSelectView.defaultValue(title: "行政区划", detail: "请选择")
            divisionSelectView.clickedCommand.subscribe { _ in

            }.disposed(by: disposeBag)
        }
    }

    @IBOutlet weak var scaleSelectView: MLCommonSelectView! {
        didSet {
            scaleSelectView.defaultValue(title: "企业规模", detail: "请选择")
            scaleSelectView.clickedCommand.subscribe { _ in

            }.disposed(by: disposeBag)
        }
    }

    @IBOutlet weak var typesSelectView: MLCommonSelectView! {
        didSet {
            typesSelectView.defaultValue(title: "企业类型", detail: "请选择")
            typesSelectView.clickedCommand.subscribe { _ in

            }.disposed(by: disposeBag)
        }
    }

    @IBOutlet weak var levelSelectView: MLCommonSelectView! {
        didSet {
            levelSelectView.defaultValue(title: "安全生产标准化达标级别", detail: "请选择")
            levelSelectView.clickedCommand.subscribe { _ in

            }.disposed(by: disposeBag)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "基本档案"
        let submitButton = UIBarButtonItem(title: "提交", style: .plain, target: self, action: #selector(submitButtonClicked))
        self.navigationItem.rightBarButtonItem = submitButton
    }
    
    @IBAction private func submitButtonClicked(_ sender: UIBarButtonItem) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
