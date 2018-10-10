//
//  MolueNavigatorDelegate.swift
//  MolueMediator
//
//  Created by MolueJames on 2018/10/2.
//  Copyright © 2018 MolueJames. All rights reserved.
//
import Foundation

public protocol MolueNavigatorDelegate: class {
    func shouldPush(viewController: UIViewController, from: UINavigationControllerType) -> Bool
    
    func shouldPresent(viewController: UIViewController, from: UIViewControllerType) -> Bool
}

extension MolueNavigatorDelegate {
    func shouldPush(viewController: UIViewController, from: UINavigationControllerType) -> Bool {
        return true
    }
    
    func shouldPresent(viewController: UIViewController, from: UIViewControllerType) -> Bool {
        return true
    }
}
