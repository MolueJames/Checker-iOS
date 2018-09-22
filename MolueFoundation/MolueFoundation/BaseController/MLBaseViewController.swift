//
//  MLBaseViewController.swift
//  MolueFoundation
//
//  Created by James on 2018/4/17.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import UIKit
import SnapKit
import MolueUtilities
import MolueNetwork
open class MLBaseViewController: UIViewController, MLNavigationProtocol, MLControllerNetworkProtocol {
    private var networkcount = 0 {
        didSet {
            self.needToDo(newValue: networkcount, oldValue: oldValue)
        }
    }
    private let height: CGFloat = MLConfigure.iPhoneX ? 88 : 64
    
    open let navigationView: UIView! = UIView()
    
    open override func loadView() {
        super.loadView()
        self.updateNavBackgroundView()
    }
    private func updateNavBackgroundView() {
        do {
            let _: UINavigationController = try self.parent.unwrap().toTarget()
            self.view.addSubview(navigationView)
            navigationView.snp.updateConstraints { (make) in
                make.height.equalTo(height)
            }
            navigationView.snp.makeConstraints { (make) in
                make.top.left.right.equalToSuperview()
            }
        } catch {
            MolueLogger.UIModule.message(error)
        }
    }
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        get { return .lightContent }
    }
    open override var prefersStatusBarHidden: Bool {
        get { return false }
    }
    open override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        get { return .slide }
    }
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.updateControllerElements()
        self.implementInterfaceProtocol()
    }
    
    private func implementInterfaceProtocol() {
        do {
            let controller: MLUserInterfaceProtocol = try self.toTarget()
            controller.queryInformationWithNetwork()
            controller.updateUserInterfaceElements()
        } catch {
            MolueLogger.UIModule.message(error)
        }
    }
    private func updateControllerElements() {
        self.automaticallyAdjustsScrollViewInsets = false;
        self.edgesForExtendedLayout = .all;
        self.view.backgroundColor = UIColor.init(hex: 0xf5f5f9)
        navigationView.backgroundColor = UIColor.init(hex: 0x1B82D2)
    }
    deinit {
        MolueLogger.dealloc.message(String(describing: self))
    }
}

extension MLBaseViewController {
    open func hideNavigationBar(animated: Bool = false) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.updateNavigationView(height: 0)
        self.navigationBarAnimate(animated)
    }
    open func showNavigationBar(animated: Bool = false) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        let height: CGFloat = MLConfigure.iPhoneX ? 88 : 64
        self.updateNavigationView(height: height)
        self.navigationBarAnimate(animated)
    }
    private func navigationBarAnimate(_ animated: Bool) {
        guard animated == true else {return}
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    open func updateNavigationView(color: UIColor) {
        navigationView.backgroundColor = color
    }
    open func updateNavigationView(height: CGFloat) {
        navigationView.snp.updateConstraints { (make) in
            make.height.equalTo(height)
        }
    }
}

extension MLBaseViewController : MolueActivityDelegate {
    public func networkActivityStarted() {
        self.networkcount = self.networkcount + 1
    }
    public func networkActivitySuccess() {
        self.networkcount = self.networkcount - 1
    }
    public func networkActivityFailure(error: Error) {
        self.networkcount = self.networkcount - 1
        self.showFailureHUD(text: error.localizedDescription)
    }
}
