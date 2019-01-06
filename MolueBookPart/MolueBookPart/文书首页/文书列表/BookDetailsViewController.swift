//
//  BookDetailsViewController.swift
//  MolueBookPart
//
//  Created by MolueJames on 2019/1/6.
//  Copyright © 2019 MolueTech. All rights reserved.
//

import UIKit
import MolueFoundation

protocol BookDetailsPresentableListener: class {
    // 定义一些当前页面需要的业务逻辑, 比如网络请求.
}

final class BookDetailsViewController: MLBaseViewController  {
    //MARK: View Controller Properties
    var listener: BookDetailsPresentableListener?
    
    //MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension BookDetailsViewController: MLUserInterfaceProtocol {
    func queryInformationWithNetwork() {
        
    }
    
    func updateUserInterfaceElements() {
        
    }
}

extension BookDetailsViewController: BookDetailsPagePresentable {
    
}

extension BookDetailsViewController: BookDetailsViewControllable {
    
}
