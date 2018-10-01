//
//  Appdelegate+UILogic.swift
//  MolueSafty
//
//  Created by James on 2018/4/27.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import Foundation
import MolueNavigator
import MolueMinePart
import MolueFoundation
import MolueUtilities
import MolueCommon
import MolueMediator
import ObjectMapper

protocol TestPresnetable : class {
    var listener: TestListenerProtocol?  {get set}
    func testClicked()
}

protocol TestListenerProtocol: class {
    
}

class TestListener: MolueLoginPageInteractable, MoluePresenterInteractable, TestListenerProtocol {
    required init(presenter: TestPresnetable) {
        self.presenter = presenter
        presenter.listener = self
    }
    
    weak var presenter: TestPresnetable?
    
    typealias Presentable = TestPresnetable
    
    func testFunction() {
        MolueLogger.success.message("clicked")
    }
}

class testPresenter: TestPresnetable {
    var listener: TestListenerProtocol?
    
    func testClicked() {
        MolueLogger.success.message("clicked")
    }
    
    
    
}

extension AppDelegate {
    func setDefaultRootViewController() {
        self.setAppRouterConfigure()
        self.setAppWindowConfigure()
        let name = MolueNotification.molue_user_login.toName()
        NotificationCenter.default.addObserver(forName: name, object: nil, queue: OperationQueue.main) { [unowned self] (_) in
            self.window?.rootViewController = self.rootViewController()
            self.window?.makeKeyAndVisible()
        }
        
        
//        self.window = UIWindow.init(frame: UIScreen.main.bounds)
//        self.window?.isHidden = false
//
//        self.window?.
////        self.window?.rootViewController = self.rootViewController()
//        self.window?.makeKeyAndVisible()
    }
    
    public func setAppWindowConfigure() {
        do {
            let window = try self.window.unwrap()
            window.isHidden = false
            let navController = UINavigationController(rootViewController: self.loginViewController()!)
            window.rootViewController = navController
            window.makeKeyAndVisible()
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    private func setAppRouterConfigure() {
//        DispatchQueue.doOnce {
            MolueAppRouter.shared.initialize()
//        }
    }
    
    private func loginViewController() -> UIViewController? {
//        let navController = MLNavigationController()
//        do {
//            let router = MolueNavigatorRouter(.Login, path: LoginPath.LoginPage.rawValue)
//            let viewController = try MolueAppRouter.shared.viewController(router).unwrap()
//            navController.viewControllers = [viewController]
//        } catch {
//            MolueLogger.UIModule.error(error)
//        }
//        return navController
        let builderFactory = MolueBuilderFactory<MolueComponent.Login>(.LoginPage)
        let builder: MolueLoginPageBuildable? = builderFactory.queryBuilder()
        let test = testPresenter()
        let listener = TestListener(presenter: test)
        return builder?.build(listener: listener)
        
    }
    
    private func rootViewController() -> UIViewController {
        var viewControllers = [MLNavigationController]()
        self.addNavigationController(module: .Home, path: HomePath.HomePageInfo.rawValue, viewControllers: &viewControllers, title:"首页", imageName: "molue_tabbar_home")
        self.addNavigationController(module: .Risk, path: RiskPath.RiskInfo.rawValue, viewControllers: &viewControllers, title:"隐患", imageName: "molue_tabbar_risk")
        self.addNavigationController(module: .Book, path: BookPath.BookInfo.rawValue, viewControllers: &viewControllers, title:"文书", imageName: "molue_tabbar_book")
        self.addNavigationController(module: .Mine, path: MinePath.MineInfo.rawValue, viewControllers: &viewControllers, title:"我的", imageName: "molue_tabbar_mine")
        
        let tabbarController = MLTabBarController()
        tabbarController.viewControllers = viewControllers
        return tabbarController
    }
    
    private func addNavigationController(module: MolueNavigatorRouter.RouterHost, path: String, viewControllers: inout [MLNavigationController], title: String, imageName: String) {
        do {
            let router = MolueNavigatorRouter(module, path: path)
            let viewController = try MolueAppRouter.shared.viewController(router).unwrap()
            viewController.tabBarItem = UITabBarItem(title: title, image: UIImage.init(named: imageName), tag: viewControllers.count)
            viewControllers.append(MLNavigationController(rootViewController: viewController))
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
}
