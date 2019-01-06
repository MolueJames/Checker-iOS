//
//  BookInfoViewController.swift
//  MolueBookPart
//
//  Created by James on 2018/5/14.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import UIKit
import RxSwift
import MolueCommon
import MolueFoundation
import MolueUtilities
protocol BookInfoPresentableListener: class {
    // 定义一些当前页面需要的业务逻辑, 比如网络请求.
    func queryBookDetailsController()
}

class BookInfoViewController: MLBaseViewController {
    var listener: BookInfoPresentableListener?
    
    @IBOutlet weak var segementView: MLCommonSegementView! {
        didSet {
            segementView.delegate = self
            let list = ["巡查文书", "执法文书", "其他文书"]
            segementView.updateSegementList(with: list)
        }
    }
    
    private var selectedIndex: Int = 0 {
        didSet {
            let list = [self.viewControllers[self.selectedIndex]]
            let isForward = oldValue < selectedIndex ? true : false
            let direction: UIPageViewController.NavigationDirection = isForward ? .forward : .reverse
            self.pageViewController.setViewControllers(list, direction: direction, animated: true)
            self.segementView.setSelectedItem(at: self.selectedIndex)
        }
    }
    
    var viewControllers: [UIViewController] = [UIViewController]()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private var pageViewController: UIPageViewController!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        do {
            self.pageViewController = try segue.destination.toTarget()
            self.pageViewController.delegate = self
            self.pageViewController.dataSource = self
        } catch {
            MolueLogger.failure.error(error)
        }
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
        do {
            let listener = try self.listener.unwrap()
            listener.queryBookDetailsController()
        } catch { MolueLogger.UIModule.error(error) }

        self.titleLabel.text = "文书列表"
        self.navigationItem.titleView = self.titleLabel
    }
}

extension BookInfoViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed && finished else { return }
        do {
            let current = try pageViewController.viewControllers.unwrap().last.unwrap()
            let selectIndex = try self.viewControllers.index(of: current).unwrap()
            self.selectedIndex = selectIndex
        } catch {
            MolueLogger.UIModule.error(error)
        }
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

extension BookInfoViewController: BookInfoPagePresentable {
    
}

extension BookInfoViewController: BookInfoViewControllable {
    func setDetailsControllers(with viewControllers: [UIViewController]) {
        self.viewControllers = viewControllers
        let list = [self.viewControllers[self.selectedIndex]]
        self.pageViewController.setViewControllers(list, direction: .forward, animated: false)
        self.segementView.setSelectedItem(at: self.selectedIndex)
    }
}

extension BookInfoViewController: MLSegementViewDelegate {
    func segementView(_ segementView: MLCommonSegementView, didSelectItemAt index: Int) {
        self.selectedIndex = index
    }
}
