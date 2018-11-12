//
//  ExistedRiskDetailViewController.swift
//  MolueHomePart
//
//  Created by MolueJames on 2018/11/11.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import UIKit
import MolueUtilities
import MolueFoundation
import MolueCommon

protocol ExistedRiskDetailPresentableListener: class {
    // 定义一些当前页面需要的业务逻辑, 比如网络请求.
    func doSubmitButtonClickedAction()
    func doCancelButtonClickedAction()
}

final class ExistedRiskDetailViewController: MLBaseViewController  {
    //MARK: View Controller Properties
    var listener: ExistedRiskDetailPresentableListener?
    
    @IBOutlet weak var uploadPhotoView: MLCommonPhotoView! {
        didSet {
            uploadPhotoView.defaultValue(title: "添加检查照片", list: [UIImage](), count: 4)
        }
    }
    //MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func submitButtonClicked(_ sender: UIButton) {
        do {
            let listener = try self.listener.unwrap()
            listener.doSubmitButtonClickedAction()
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    @IBAction func cancelButtonClicked(_ sender: UIButton) {
        do {
            let listener = try self.listener.unwrap()
            listener.doCancelButtonClickedAction()
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
}

extension ExistedRiskDetailViewController: MLUserInterfaceProtocol {
    func queryInformationWithNetwork() {
        
    }
    
    func updateUserInterfaceElements() {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
    }
}

extension ExistedRiskDetailViewController: ExistedRiskDetailPagePresentable {
    
}

extension ExistedRiskDetailViewController: ExistedRiskDetailViewControllable {
    
}
