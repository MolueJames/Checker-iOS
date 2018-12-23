//
//  UserLoginPagePageInteractor.swift
//  MolueLoginPart
//
//  Created by MolueJames on 2018/10/14.
//  Copyright © 2018 MolueJames. All rights reserved.
//

import MolueMediator
import MolueUtilities
import MolueDatabase
import MolueCommon
import MolueNetwork

protocol UserLoginPageViewableRouting: class {
    // 定义一些页面跳转的方法, 比如Push, Presenter等.
    func pushForgetPasswordViewController()
}

protocol UserLoginPagePagePresentable: MolueInteractorPresentable, MolueActivityDelegate {
    var listener: UserLoginPagePresentableListener? { get set }
    // 定义一些页面需要的方法, 比如刷新页面的显示内容等.
}

final class UserLoginPagePageInteractor: MoluePresenterInteractable, UserLoginPageRouterInteractable, UserLoginPagePresentableListener {
    func doUserLogin(with username: String, password: String) {
        let request = MolueOauthService.doLogin(username: username, password: password)
        request.handleSuccessResultToObjc { [weak self] (result: MolueOauthModel?) in
            do {
                let oauthItem = try result.unwrap()
                let strongSelf = try self.unwrap()
                strongSelf.successOperation(oauthItem, username: username)
                strongSelf.queryUserInfoFromServer()
            } catch { MolueLogger.network.message(error) }
        }
        let requestManager = MolueRequestManager(delegate: self.presenter)
        requestManager.doRequestStart(with: request ,needOauth: false)
    }
    
    private func successOperation(_ item: MolueOauthModel, username: String) {
        let filePath = MolueCryption.MD5(username)
        MolueUserLogic.doConnectWithDatabase(path: filePath)
        MolueOauthModel.updateOauthItem(with: item)
        
        let name = MolueNotification.molue_user_login.toName()
        NotificationCenter.default.post(name: name, object: nil)
    }
    
    func queryUserInfoFromServer () {
        let request = MolueUserInfoService.queryUserInformation()
        request.handleSuccessResultToObjc { (result: MolueUserInfo?) in
            do {
                try MolueUserInfo.updateUserInfo(with: result.unwrap())
            } catch {
                MolueLogger.network.message(error)
            }
        }
        MolueRequestManager().doRequestStart(with: request)
    }

    
    func routerToForgetPassword() {
        do {
            let router = try self.viewRouter.unwrap()
            router.pushForgetPasswordViewController()
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }

    weak var presenter: UserLoginPagePagePresentable?
    
    var viewRouter: UserLoginPageViewableRouting?
    
    weak var listener: UserLoginPageInteractListener?
    
    required init(presenter: UserLoginPagePagePresentable) {
        self.presenter = presenter
        presenter.listener = self
    }
    
    deinit {
        MolueLogger.dealloc.message(String(describing: self))
    }
}
