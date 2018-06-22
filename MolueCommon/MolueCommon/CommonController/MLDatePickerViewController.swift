//
//  MLDatePickerViewController.swift
//  MolueCommon
//
//  Created by MolueJames on 2018/6/11.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import UIKit
import MolueUtilities
import MolueFoundation
public protocol MLDatePickerProtocol: NSObjectProtocol {
    func selectDate(_ date: Date, string: String, controller: MLDatePickerViewController)
}

public class MLDatePickerViewController: MLBaseViewController {
    private var pickDate: Date = Date()
    
    private var warning = "请选择有效日期"
    
    private var dateFormat = "yyyy年MM月dd日"
    
    private var pickerMode = UIDatePickerMode.date
    
    public weak var delegate: MLDatePickerProtocol?
    
    public func changeDefault(warning: String, format: String, mode: UIDatePickerMode) {
        self.warning = warning
        self.dateFormat = format
        self.pickerMode = mode
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
            datePicker.datePickerMode = pickerMode
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
        let string = pickDate.string(withFormat: dateFormat)
        self.delegate?.selectDate(pickDate, string: string, controller: self)
        self.dismissViewController()
    }
}
