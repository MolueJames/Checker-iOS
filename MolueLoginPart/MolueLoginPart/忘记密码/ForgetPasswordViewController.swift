//
//  ForgetPasswordViewController.swift
//  MolueLoginPart
//
//  Created by MolueJames on 2018/10/1.
//  Copyright © 2018年 MolueJames. All rights reserved.
//

import UIKit
import MolueFoundation

protocol ForgetPwdPresentableListener: class {
    func backButtonClicked()
}

class ForgetPasswordViewController: MLBaseViewController, MolueForgetPwdPresentable {
    var listener: ForgetPwdPresentableListener?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButtonClicked(_ sender: UIButton) {
//        self.listener?.backButtonClicked()
        self.navigationController?.popViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
