//___FILEHEADER___

import MolueMediator
import MolueUtilities

protocol ___VARIABLE_productName___RouterInteractable: class {
    var viewRouter: ___VARIABLE_productName___ViewableRouting? { get set }
    var listener: ___VARIABLE_productName___InteractListener? { get set }
}

protocol ___VARIABLE_productName___ViewControllable: class {
    // 定义一些该页面需要的其他commponent的组件, 比如该页面的childViewController等.
}

final class ___VARIABLE_productName___ViewableRouter: MolueViewableRouting, ___VARIABLE_productName___ViewableRouting {
    
    typealias Interactable = ___VARIABLE_productName___RouterInteractable
    weak var interactor: Interactable?
    
    typealias Controllable = ___VARIABLE_productName___ViewControllable
    weak var controller: Controllable?
    
    @discardableResult
    required init(interactor: Interactable, controller: Controllable) {
        self.controller = controller
        self.interactor = interactor
        interactor.viewRouter = self
    }
    
    deinit {
        MolueLogger.dealloc.message(String(describing: self))
    }
}

protocol ___VARIABLE_productName___InteractListener: class {
    //用于定义其他的Component需要定义的协议方法
}

protocol ___VARIABLE_productName___ComponentBuildable: MolueComponentBuildable {
    //定义当前的Component的构造方法.
    func build(listener: ___VARIABLE_productName___InteractListener) -> UIViewController
}

class ___VARIABLE_productName___ComponentBuilder: MolueComponentBuilder, ___VARIABLE_productName___ComponentBuildable {
    func build(listener: ___VARIABLE_productName___InteractListener) -> UIViewController {
        let controller = ___VARIABLE_productName___ViewController()
        let interactor = ___VARIABLE_productName___PageInteractor(presenter: controller)
        ___VARIABLE_productName___ViewableRouter(interactor: interactor, controller: controller)
        interactor.listener = listener
        return controller
    }
    
    deinit {
        MolueLogger.dealloc.message(String(describing: self))
    }
}
