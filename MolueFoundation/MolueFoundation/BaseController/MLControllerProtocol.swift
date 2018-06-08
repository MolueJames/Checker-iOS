//
//  MLViewControllerProtocol.swift
//  MolueFoundation
//
//  Created by James on 2018/5/7.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import Foundation
import MolueNetwork
import MolueUtilities
import JGProgressHUD
import NVActivityIndicatorView
typealias MLControllerNetworkProtocol = MLControllerHUDProtocol & MLLoadingIndicatorProtocol

fileprivate let hud_display_duration = 0.5

public protocol MLControllerHUDProtocol {
    func showSuccessHUD(text: String)
    func showFailureHUD(text: String)
    func showWarningHUD(text: String)
}

protocol MLLoadingIndicatorProtocol {
    func showLoadingIndicatorView()
    func hideLoadingIndicatorView()
    func needToDo(newValue: Int, oldValue: Int)
}

extension MLLoadingIndicatorProtocol where Self: UIViewController {
    func showLoadingIndicatorView() {
        let data = ActivityData()
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(data)
    }
    func hideLoadingIndicatorView() {
        NVActivityIndicatorPresenter.sharedInstance.setMessage("加载数据中...")
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
    }
    func needToDo(newValue: Int, oldValue: Int) {
        if newValue > 0 && oldValue <= 0{
            self.showLoadingIndicatorView()
        } else if oldValue > 0 && newValue <= 0{
            self.hideLoadingIndicatorView()
        }
    }
}

extension MLControllerHUDProtocol where Self: UIViewController {
    public func showSuccessHUD(text: String) {
        let image = UIImage(named: "foundation_icon_success")
        guard let hud = self.createHUD(text: text, image: image)  else {
            MolueLogger.UIModule.error("the hud is not existed")
            return
        }
        self.showHUDAfterDismiss(hud)
    }
    public func showFailureHUD(text: String) {
        let image = UIImage(named: "foundation_icon_failure")
        guard let hud = self.createHUD(text: text, image: image) else {
            MolueLogger.UIModule.error("the hud is not existed")
            return
        }
        self.showHUDAfterDismiss(hud)
    }
    public func showWarningHUD(text: String) {
        guard text.isEmpty == false else {return}
        guard let hud = self.createHUD(text: text, image: UIImage()) else {
            MolueLogger.UIModule.error("the hud is not existed")
            return
        }
        self.showHUDAfterDismiss(hud)
    }
    private func createHUD(text: String, image: UIImage?) -> JGProgressHUD? {
        guard let hud = JGProgressHUD.init(style: JGProgressHUDStyle.dark) else {
            MolueLogger.UIModule.error("the hud is not existed")
            return nil
        }
        hud.indicatorView = JGProgressHUDImageIndicatorView.init(image: image)
        hud.textLabel.text = text
        return hud
    }
    private func showHUDAfterDismiss(_ HUD: JGProgressHUD) {
        HUD.show(in: self.view, animated: true)
        HUD.dismiss(afterDelay: hud_display_duration, animated: true)
    }
}

protocol MLNavigationProtocol {
    var customBackBarButtonItem: UIBarButtonItem {get}
}

protocol MLNavigationPopProtocol where Self: UIViewController {
    func navigationShouldPopOnBackButton(_ sender: UINavigationItem)
}

extension MLNavigationProtocol {
    var customBackBarButtonItem: UIBarButtonItem { get {
        return UIBarButtonItem.init(title: "返回", style: .plain, target: nil, action: nil)
        }
    }
}
