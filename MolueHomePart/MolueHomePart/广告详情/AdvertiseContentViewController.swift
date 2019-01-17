//
//  AdvertiseContentViewController.swift
//  MolueHomePart
//
//  Created by MolueJames on 2019/1/15.
//  Copyright © 2019 MolueTech. All rights reserved.
//

import UIKit
import MolueUtilities
import MolueFoundation
import MolueMediator

protocol AdvertiseContentPresentableListener: class {
    // 定义一些当前页面需要的业务逻辑, 比如网络请求.
    var advertisement: MLAdvertiseContent? { get }
}

final class AdvertiseContentViewController: MLBaseViewController  {
    //MARK: View Controller Properties
    var listener: AdvertiseContentPresentableListener?
    
    //MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension AdvertiseContentViewController: MLUserInterfaceProtocol {
    func queryInformationWithNetwork() {
        
    }
    
    func updateUserInterfaceElements() {
        do {
            let listener = try self.listener.unwrap()
            let advertise = try listener.advertisement.unwrap()
            self.title = try advertise.title.unwrap()
        } catch {
            MolueLogger.UIModule.message(error)
        }
    }
}

extension AdvertiseContentViewController: AdvertiseContentPagePresentable {
    
}

extension AdvertiseContentViewController: AdvertiseContentViewControllable {
    
}
