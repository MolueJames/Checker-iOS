//
//  MolueViewableRouting.swift
//  MolueMediator
//
//  Created by MolueJames on 2018/10/3.
//  Copyright © 2018 MolueJames. All rights reserved.
//

import Foundation
public protocol MolueViewableRouting: class {
    associatedtype Controllerable
    associatedtype Interactable
    var interactor: Interactable? {get set}
    var controller: Controllerable? {get set}
    init(interactor: Interactable, controller: Controllerable)
}

public protocol MolueViewControllable: class {
    func doPopBack(to controller: UIViewController, animated flag: Bool)
    func doDismiss(animated flag: Bool, completion: (() -> Void)?)
    func popBackToRoot(animated flag: Bool)
    func doPopBackFromCurrent()
    func pushToViewController(_ controller: UIViewController, animated flag: Bool)
    func doPresentController(_ controller: UIViewController, animated flag: Bool, completion: (() -> Void)?)
}

public extension MolueViewControllable where Self: UIViewController {
    public func doPopBackFromCurrent() {
        self.navigationController?.popViewController(animated: true)
    }
    
    public func doDismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        self.dismiss(animated: flag, completion: completion)
    }
    
    public func doPopBack(to controller: UIViewController, animated flag: Bool) {
        self.navigationController?.popToViewController(controller, animated: flag)
    }
    
    public func popBackToRoot(animated flag: Bool) {
        self.navigationController?.popToRootViewController(animated: flag)
    }
    
    public func pushToViewController(_ controller: UIViewController, animated flag: Bool) {
        self.navigationController?.pushViewController(controller, animated: flag)
    }
    public func doPresentController(_ controller: UIViewController, animated flag: Bool, completion: (() -> Void)?) {
        self.present(controller, animated: flag, completion: completion)
    }
}
