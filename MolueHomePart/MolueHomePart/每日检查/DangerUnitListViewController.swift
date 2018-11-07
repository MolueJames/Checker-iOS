//
//  DangerUnitListViewController.swift
//  MolueHomePart
//
//  Created by JamesCheng on 2018-11-06.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import UIKit
import MolueUtilities
import MolueFoundation

protocol DangerUnitListPresentableListener: class {
    // 定义一些当前页面需要的业务逻辑, 比如网络请求.
    var valueList: [String] {get}
    
    func jumpToDailyCheckTaskController()
}

final class DangerUnitListViewController: MLBaseViewController  {
    //MARK: View Controller Properties
    var listener: DangerUnitListPresentableListener?
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(xibWithCellClass: DangerUnitCollectionViewCell.self)
            collectionView.collectionViewLayout = self.collectionViewLayout
        }
    }
    
    lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let viewLayout = UICollectionViewFlowLayout()
        let size = (MLConfigure.ScreenWidth - 30) / 2 - 1
        viewLayout.itemSize = CGSize(width: size, height: 90)
        viewLayout.scrollDirection = .vertical
        viewLayout.sectionInset = UIEdgeInsetsMake(10, 10, 0, 10)
        viewLayout.minimumLineSpacing = 10
        viewLayout.minimumInteritemSpacing = 10
        return viewLayout
    }()
    
    //MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension DangerUnitListViewController: MLUserInterfaceProtocol {
    func queryInformationWithNetwork() {
        
    }
    
    func updateUserInterfaceElements() {
        self.title = "风险单元"
        self.collectionView.backgroundColor = .red
    }
}

extension DangerUnitListViewController: DangerUnitListPagePresentable {
    
}

extension DangerUnitListViewController: DangerUnitListViewControllable {
    
}

extension DangerUnitListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        do {
            let listener = try self.listener.unwrap()
            listener.jumpToDailyCheckTaskController()
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
}

extension DangerUnitListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        do {
            let listener = try self.listener.unwrap()
            return listener.valueList.count
        } catch { return 1 }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: DangerUnitCollectionViewCell.self, for: indexPath)
        
        return cell
    }
}
