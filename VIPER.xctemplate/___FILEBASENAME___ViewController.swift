//___FILEHEADER___

import UIKit
import MolueFoundation

protocol ___VARIABLE_productName___PresentableListener: class {
    // 定义一些当前页面需要的业务逻辑, 比如网络请求.
}

final class ___VARIABLE_productName___ViewController: MLBaseViewController, ___VARIABLE_productName___PagePresentable, ___VARIABLE_productName___ViewControllable {

    var listener: ___VARIABLE_productName___PresentableListener?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension ___VARIABLE_productName___ViewController: MLUserInterfaceProtocol {
    func queryInformationWithNetwork() {
        
    }
    
    func updateUserInterfaceElements() {
        
    }
}
