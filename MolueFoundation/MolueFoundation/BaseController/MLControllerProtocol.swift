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
public protocol MLUserInterfaceProtocol {
    func queryInformationWithNetwork()
    func updateUserInterfaceElements()
}

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
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(data, nil)
    }
    func hideLoadingIndicatorView() {
        NVActivityIndicatorPresenter.sharedInstance.setMessage("加载数据中...")
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
    }
    func needToDo(newValue: Int, oldValue: Int) {
        let value = showOrLoadIndicatorView.switchShowHide(new: newValue, old: oldValue)
        if value == .needHide {
            self.hideLoadingIndicatorView()
        } else if value == .needShow {
            self.showLoadingIndicatorView()
        }
    }
}

fileprivate enum showOrLoadIndicatorView {
    case needShow
    case needHide
    case keepLoad
    static func switchShowHide(new: Int, old: Int) -> showOrLoadIndicatorView {
        if new > 0 && old <= 0 {
            return .needShow
        } else if old > 0 && new <= 0 {
            return .needHide
        }
        return .keepLoad
    }
}

extension MLControllerHUDProtocol where Self: UIViewController {
    public func showSuccessHUD(text: String) {
        do {
            let image = try UIImage(named: "foundation_icon_success").unwrap()
            let hud = try self.createHUD(text: text, image: image).unwrap()
            self.showHUDAfterDismiss(hud)
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    public func showFailureHUD(text: String) {
        do {
            let image = try UIImage(named: "foundation_icon_failure").unwrap()
            let hud = try self.createHUD(text: text, image: image).unwrap()
            self.showHUDAfterDismiss(hud)
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    public func showWarningHUD(text: String) {
        do {
            guard text.isEmpty == false else {return}
            let hud = try self.createHUD(text: text, image: UIImage()).unwrap()
            self.showHUDAfterDismiss(hud)
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    private func createHUD(text: String, image: UIImage?) -> JGProgressHUD? {
        do {
            let ProgressHUD = JGProgressHUD(style: JGProgressHUDStyle.dark)
            let hud = try ProgressHUD.unwrap()
            hud.indicatorView = JGProgressHUDImageIndicatorView(image: image)
            hud.textLabel.text = text
            return hud
        } catch {
            return MolueLogger.UIModule.returnNil(error)
        }
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
