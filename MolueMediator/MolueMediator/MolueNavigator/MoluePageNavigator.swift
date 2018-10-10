
//
//  MolueNavigatorType.swift
//  MolueMediator
//
//  Created by MolueJames on 2018/10/3.
//  Copyright © 2018 MolueJames. All rights reserved.
//

import Foundation

open class MoluePageNavigator: MolueNavigatorType {
    open weak var delegate: MolueNavigatorDelegate?
    
    public init() {}
}

public protocol MolueNavigatorType {
    var delegate: MolueNavigatorDelegate? { get set }
    
    @discardableResult
    func pushViewController(_ viewController: UIViewController, from: UINavigationControllerType?, animated: Bool) -> UIViewController?
    
    @discardableResult
    func presentViewController(_ viewController: UIViewController, wrap: UINavigationController.Type?, from: UIViewControllerType?, animated: Bool, completion: (() -> Void)?) -> UIViewController?
}

extension MolueNavigatorType {
    @discardableResult
    public func pushViewController(_ viewController: UIViewController, from: UINavigationControllerType? = nil, animated: Bool = true) -> UIViewController? {
        guard (viewController is UINavigationController) == false else { return nil }
        guard let navigationController = from ?? UIViewController.topMost?.navigationController else { return nil }
        guard self.delegate?.shouldPush(viewController: viewController, from: navigationController) != false else { return nil }
        navigationController.pushViewController(viewController, animated: animated)
        return viewController
    }
    
    @discardableResult
    public func presentViewController(_ viewController: UIViewController, wrap: UINavigationController.Type? = nil, from: UIViewControllerType? = nil, animated: Bool = true, completion: (() -> Void)? = nil) -> UIViewController? {
        guard let fromViewController = from ?? UIViewController.topMost else { return nil }
        
        let viewControllerToPresent: UIViewController
        if let navigationControllerClass = wrap, (viewController is UINavigationController) == false {
            viewControllerToPresent = navigationControllerClass.init(rootViewController: viewController)
        } else {
            viewControllerToPresent = viewController
        }
        
        guard self.delegate?.shouldPresent(viewController: viewController, from: fromViewController) != false else { return nil }
        fromViewController.present(viewControllerToPresent, animated: animated, completion: completion)
        return viewController
    }
}
