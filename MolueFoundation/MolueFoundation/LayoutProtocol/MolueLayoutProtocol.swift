//
//  MolueLayoutProtocol.swift
//  MolueFoundation
//
//  Created by MolueJames on 2018/9/22.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import Foundation

public protocol MolueControllerLayout where Self: MLBaseViewController {
    func doControllerLayout()
}

public protocol MolueViewElementLayout where Self: UIView {
    func doViewElementLayout()
}

//protocol MLTestLayoutElements: MolueControllerLayout {
//    var headerImageView: UIImageView! {get}
//}
//extension MLTestLayoutElements where Self: MLTestController {
//    func doControllerLayout() {
//        self.headerImageView.snp.makeConstraints { (make) in
//            make.top.bottom.left.right.equalToSuperview()
//        }
//    }
//}
//
//class MLTestController: MLBaseViewController, MLTestLayoutElements {
//    lazy var headerImageView: UIImageView! = {
//        let imageView = UIImageView()
//        return imageView
//    }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.doControllerLayout()
//    }
//}



