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
    private var navBackgroundView: UIView! {
        didSet {
            self.view.addSubview(navBackgroundView)
            let height: CGFloat = MLConfigure.iPhoneX ? 88 : 64
            navBackgroundView.snp.updateConstraints { (make) in
                make.height.equalTo(height)
            }
            navBackgroundView.snp.makeConstraints { (make) in
                make.top.left.right.equalToSuperview()
            }
        }
    }
    open override func loadView() {
        super.loadView()
        self.updateNavBackgroundView()
    }
    private func updateNavBackgroundView() {
        guard let _ = self.navigationController else { return }
        navBackgroundView = UIView()
        navBackgroundView.backgroundColor = UIColor.init(hex: 0x1B82D2)
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
        self.automaticallyAdjustsScrollViewInsets = false;
        self.edgesForExtendedLayout = .all;
        self.view.backgroundColor = UIColor.init(hex: 0xf5f5f9)
    }
    deinit {
        MolueLogger.dealloc.message(String(describing: self))
    }
}

extension MLBaseViewController {
    open func hideNavigationBar(animated: Bool = false) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        navBackgroundView.snp.updateConstraints { (make) in
            make.height.equalTo(0)
        }
        self.navigationBarAnimate(animated)
    }
    open func showNavigationBar(animated: Bool = false) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        let height: CGFloat = MLConfigure.iPhoneX ? 88 : 64
        navBackgroundView.snp.updateConstraints { (make) in
            make.height.equalTo(height)
        }
        self.navigationBarAnimate(animated)
    }
    private func navigationBarAnimate(_ animated: Bool) {
        guard animated == true else {return}
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    open func updateNavigationBarBackgroundColor(_ color: UIColor) {
        navBackgroundView.backgroundColor = color
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
