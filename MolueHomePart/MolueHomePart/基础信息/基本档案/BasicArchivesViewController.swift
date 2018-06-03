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
    @IBOutlet weak var CodeContainerView: MLContainerView! {
        didSet {
            codeInputView = MLCommonInputView.createFromXib()
            CodeContainerView.addSubview(codeInputView)
            codeInputView.snp.makeConstraints { (make) in
                make.top.bottom.equalToSuperview()
                make.left.right.equalToSuperview()
            }
        }
    }
    var codeInputView: MLCommonInputView! {
        didSet {
            codeInputView.titleLabel.text = "信用代码"
            codeInputView.textFiled.placeholder = "请输入18位统一社会信用代码"
        }
    }
    
    @IBOutlet weak var DivisionContainerView: MLContainerView! {
        didSet {
            divisionSelectView = MLCommonSelectView.createFromXib()
            DivisionContainerView.addSubview(divisionSelectView)
            divisionSelectView.snp.makeConstraints { (make) in
                make.top.bottom.equalToSuperview()
                make.left.right.equalToSuperview()
            }
        }
    }
    var divisionSelectView: MLCommonSelectView! {
        didSet {
            divisionSelectView.titleLabel.text = "行政区划"
            divisionSelectView.descriptionLabel.text = "请选择"
            divisionSelectView.clickedCommand.subscribe { _ in
                
            }.disposed(by: disposeBag)
        }
    }
    
    @IBOutlet weak var ScaleContainerView: MLContainerView! {
        didSet {
            scaleSelectView = MLCommonSelectView.createFromXib()
            ScaleContainerView.addSubview(scaleSelectView)
            scaleSelectView.snp.makeConstraints { (make) in
                make.top.bottom.equalToSuperview()
                make.left.right.equalToSuperview()
            }
        }
    }
    
    var scaleSelectView: MLCommonSelectView! {
        didSet {
            scaleSelectView.titleLabel.text = "企业规模"
            scaleSelectView.descriptionLabel.text = "请选择"
            scaleSelectView.clickedCommand.subscribe { _ in
                
            }.disposed(by: disposeBag)
        }
    }
    
    @IBOutlet weak var TypesContainerView: MLContainerView! {
        didSet {
            typesSelectView = MLCommonSelectView.createFromXib()
            TypesContainerView.addSubview(typesSelectView)
            typesSelectView.snp.makeConstraints { (make) in
                make.top.bottom.equalToSuperview()
                make.left.right.equalToSuperview()
            }
        }
    }
    
    var typesSelectView: MLCommonSelectView! {
        didSet {
            typesSelectView.titleLabel.text = "企业类型"
            typesSelectView.descriptionLabel.text = "请选择"
            typesSelectView.clickedCommand.subscribe { _ in
                
            }.disposed(by: disposeBag)
        }
    }
    
    @IBOutlet weak var LevelContainerView: MLContainerView! {
        didSet {
            levelSelectView = MLCommonSelectView.createFromXib()
            LevelContainerView.addSubview(levelSelectView)
            levelSelectView.snp.makeConstraints { (make) in
                make.top.bottom.equalToSuperview()
                make.left.right.equalToSuperview()
            }
        }
    }
    
    var levelSelectView: MLCommonSelectView! {
        didSet {
            levelSelectView.titleLabel.text = "安全生产标准化达标级别"
            levelSelectView.descriptionLabel.text = "请选择"
            levelSelectView.clickedCommand.subscribe { _ in
                
            }.disposed(by: disposeBag)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "基本档案"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
