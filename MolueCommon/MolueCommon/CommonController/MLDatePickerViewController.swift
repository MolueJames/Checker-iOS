//
//  MLDatePickerViewController.swift
//  MolueCommon
//
//  Created by MolueJames on 2018/6/11.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import UIKit
import RxSwift
import MolueUtilities
import MolueFoundation
public class MLDatePickerViewController: MLBaseViewController {
    private var pickDate: Date = Date()
    private var warning: String = "请选择有效日期"
    public let selectDateCommand = PublishSubject<(date: Date, string: String)>()
    
    public func update(warning: String) {
        self.warning = warning
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let color = UIColor.black.withAlphaComponent(0.3)
        self.view.backgroundColor = color
    }

    open override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet private weak var datePicker: UIDatePicker! {
        didSet {
            datePicker.date = Date()
            datePicker.addTarget(self, action: #selector(pickerValueChanged), for: .valueChanged)
            self.pickDate = datePicker.date
        }
    }
    @IBAction private func pickerValueChanged(_ sender: UIDatePicker) {
        self.pickDate = sender.date
    }
    
    @IBAction private func cancelButtonClicked(_ sender: UIButton) {
        self.dismissViewController()
    }
    
    private func dismissViewController() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func submitButtonClicked(_ sender: UIButton) {
        let string = pickDate.string(withFormat: "yyyy年-MM月-dd日")
        self.selectDateCommand.onNext((date: pickDate, string: string))
        self.dismissViewController()
    }
}
