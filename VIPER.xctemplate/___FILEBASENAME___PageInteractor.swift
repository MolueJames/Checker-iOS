//___FILEHEADER___

import MolueMediator
import MolueUtilities

protocol ___VARIABLE_productName___ViewableRouting: class {
    // 定义一些页面跳转的方法, 比如Push, Presenter等.
}

protocol ___VARIABLE_productName___PagePresentable: MolueInteractorPresentable {
    var listener: ___VARIABLE_productName___PresentableListener? { get set }
    // 定义一些页面需要的方法, 比如刷新页面的显示内容等.
}

final class ___VARIABLE_productName___PageInteractor: MoluePresenterInteractable, ___VARIABLE_productName___RouterInteractable, ___VARIABLE_productName___PresentableListener {
    
    typealias Presentable = ___VARIABLE_productName___PagePresentable
    weak var presenter: Presentable?
    
    var viewRouter: ___VARIABLE_productName___ViewableRouting?
    
    weak var listener: ___VARIABLE_productName___InteractListener?
    
    required init(presenter: Presentable) {
        self.presenter = presenter
        presenter.listener = self
    }
    
    deinit {
        MolueLogger.dealloc.message(String(describing: self))
    }
}
