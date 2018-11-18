//
//  EditRiskInfoViewController.swift
//  MolueRiskPart
//
//  Created by MolueJames on 2018/11/17.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import UIKit
import MolueUtilities
import MolueFoundation

protocol EditRiskInfoPresentableListener: class {
    // 定义一些当前页面需要的业务逻辑, 比如网络请求.
    func queryNeedEditRiskImages() -> [UIImage]
}

final class EditRiskInfoViewController: MLBaseViewController  {
    //MARK: View Controller Properties
    var listener: EditRiskInfoPresentableListener?
    
    //MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension EditRiskInfoViewController: MLUserInterfaceProtocol {
    func queryInformationWithNetwork() {
        
    }
    
    func updateUserInterfaceElements() {
        do {
            let listener = try self.listener.unwrap()
            let images = listener.queryNeedEditRiskImages()
            MolueLogger.UIModule.message(images)
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
}

extension EditRiskInfoViewController: EditRiskInfoPagePresentable {
    
}

extension EditRiskInfoViewController: EditRiskInfoViewControllable {
    
}
