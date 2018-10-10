//
//  UINavigationControllerType.swift
//  MolueMediator
//
//  Created by MolueJames on 2018/10/2.
//  Copyright © 2018 MolueJames. All rights reserved.
//

import Foundation

public protocol UINavigationControllerType {
    func pushViewController(_ viewController: UIViewController, animated: Bool)
}

public protocol UIViewControllerType {
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?)
}

extension UINavigationController: UINavigationControllerType{}
extension UIViewController: UIViewControllerType{}
