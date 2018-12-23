//
//  UserInfoCenterPageInteractor.swift
//  MolueMinePart
//
//  Created by MolueJames on 2018/11/4.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import MolueMediator
import MolueCommon
import MolueUtilities
import MolueNetwork

protocol UserInfoCenterViewableRouting: class {
    // 定义一些页面跳转的方法, 比如Push, Presenter等.
    func pushToMessageCenterController()
    func pushToAboutUsInfoController()
}

protocol UserInfoCenterPagePresentable: MolueInteractorPresentable, MolueActivityDelegate {
    var listener: UserInfoCenterPresentableListener? { get set }
    // 定义一些页面需要的方法, 比如刷新页面的显示内容等.
    func refreshHeaderView(with user: MolueUserInfo)
}

final class UserInfoCenterPageInteractor: MoluePresenterInteractable {
    
    weak var presenter: UserInfoCenterPagePresentable?
    
    var viewRouter: UserInfoCenterViewableRouting?
    
    weak var listener: UserInfoCenterInteractListener?
    
    var tableViewAdapter: MLTableViewAdapter<UserInfoCenterTableViewCell, UserInfoCenterMethod>?
    
    var valueList: [UserInfoCenterMethod] = UserInfoCenterMethod.allCases
    
    required init(presenter: UserInfoCenterPagePresentable) {
        self.presenter = presenter
        presenter.listener = self
    }
}

extension UserInfoCenterPageInteractor: UserInfoCenterRouterInteractable {
    
}

extension UserInfoCenterPageInteractor: UserInfoCenterPresentableListener {
    func doUserLogoutOperater() {
        MolueUserLogic.disconnectWithDatabase()
        let name = MolueNotification.molue_need_login.toName()
        NotificationCenter.default.post(name: name, object: nil)
    }
    
    func bindingTableViewAdapter(with tableView: UITableView) {
        self.tableViewAdapter = MLTableViewAdapter<UserInfoCenterTableViewCell, UserInfoCenterMethod>(with: self.valueList)
        self.tableViewAdapter?.bindingTableView(tableView)
        self.tableViewAdapter?.heightForEachRow(50)
        self.tableViewAdapter?.cellForRowAtClosure({ (indexPath, cell, item) in
            cell.refreshSubviews(with: item)
        })
        self.tableViewAdapter?.didSelectRowAtClosure({ [weak self] (indexPath, item) in
            guard let self = self else {return}
            self.didUserSelectedLogic(with: item)
        })
    }
    
    func didUserSelectedLogic(with item: UserInfoCenterMethod) {
        func doVersionMethod() {}
        
        func doMessageMethod() {
            do {
                let viewRouter = try self.viewRouter.unwrap()
                viewRouter.pushToMessageCenterController()
            } catch {
                MolueLogger.UIModule.error(error)
            }
        }
        
        func doAboutUsMethod() {
            do {
                let viewRouter = try self.viewRouter.unwrap()
                viewRouter.pushToAboutUsInfoController()
            } catch {
                MolueLogger.UIModule.error(error)
            }
        }
        
        switch item {
        case .version: doVersionMethod()
        case .message: doMessageMethod()
        case .aboutUs: doAboutUsMethod()
        }
    }
    
    func queryUserInfoFromServer () {
        let request = MolueUserInfoService.queryUserInformation()
        request.handleSuccessResultToObjc { [weak self] (result: MolueUserInfo?) in
            do {
                let presenter = try self.unwrap().presenter.unwrap()
                try presenter.refreshHeaderView(with: result.unwrap())
                try MolueUserInfo.updateUserInfo(with: result.unwrap())
            } catch {
                MolueLogger.network.message(error)
            }
        }
        MolueRequestManager().doRequestStart(with: request)
    }
    
    func queryUserInfoFromDatabase() {
        do {
            let user = MolueUserInfo.queryUserInfo()
            let presenter = try self.presenter.unwrap()
            try presenter.refreshHeaderView(with: user.unwrap())
        } catch {
            MolueLogger.database.message(error)
        }
    }
}
