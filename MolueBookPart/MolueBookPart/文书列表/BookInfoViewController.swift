//
//  BookInfoViewController.swift
//  MolueBookPart
//
//  Created by James on 2018/5/14.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import UIKit
import RxSwift
import MolueFoundation
import MolueUtilities
class BookInfoViewController: MLBaseViewController {
    private let disposeBag = DisposeBag()
    @IBOutlet private weak var selectedView: BookInfoSectionView! {
        didSet {
            self.selectedView.selectedCommand.subscribe(onNext: { [unowned self] (index) in
                self.selectedIndex = index
            }).disposed(by: disposeBag)
        }
    }
    private var selectedIndex: Int = 0 {
        didSet {
            let list = [self.viewControllers[self.selectedIndex]]
            let isForward = oldValue < selectedIndex ? true : false
            let direction: UIPageViewControllerNavigationDirection = isForward ? .forward : .reverse
            self.pageViewController.setViewControllers(list, direction: direction, animated: true)
            self.selectedView.setSelectedIndex(self.selectedIndex, animated: true)
        }
    }
    
    private var viewControllers: [UIViewController] = {
        var viewControllers = [UIViewController]()
        viewControllers.append(BookDetailViewController())
        viewControllers.append(BookDetailViewController())
        return viewControllers
    }()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private var pageViewController: UIPageViewController!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.pageViewController = segue.destination as! UIPageViewController
        self.pageViewController.delegate = self
        self.pageViewController.dataSource = self
    }
    
    lazy var titleLabel: UILabel! = {
        let label = UILabel.init()
        label.font = .boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.textColor = UIColor.white
        return label
    } ()
}
extension BookInfoViewController: MLUserInterfaceProtocol {
    func queryInformationWithNetwork() {
        
    }
    
    func updateUserInterfaceElements() {
        let list = [self.viewControllers[self.selectedIndex]]
        self.pageViewController.setViewControllers(list, direction: .forward, animated: false)
        self.selectedView.setSelectedIndex(self.selectedIndex, animated: false)
        
        self.titleLabel.text = "文书列表"
        self.navigationItem.titleView = self.titleLabel
    }
}

extension BookInfoViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed && finished else { return }
        guard let current = pageViewController.viewControllers?.last else {
            MolueLogger.UIModule.error("the current is not existed"); return
        }
        guard let selectIndex = self.viewControllers.index(of: current) else {
            MolueLogger.UIModule.error("the selected index is not existed"); return
        }
        self.selectedIndex = selectIndex
    }
}

extension BookInfoViewController: UIPageViewControllerDataSource {
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return self.selectedIndex > 0 ? self.viewControllers[self.selectedIndex - 1] : nil
    }
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return  self.selectedIndex < self.viewControllers.count - 1 ? self.viewControllers[self.selectedIndex + 1] : nil
    }
}
