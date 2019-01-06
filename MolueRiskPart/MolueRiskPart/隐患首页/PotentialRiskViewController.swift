//
//  PotentialRiskViewController.swift
//  MolueRiskPart
//
//  Created by MolueJames on 2018/10/31.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import UIKit
import MolueFoundation
import MolueUtilities
import MolueCommon
import MolueMediator

protocol PotentialRiskPresentableListener: class {
    // 定义一些当前页面需要的业务逻辑, 比如网络请求.
    func queryPerilListController()
}

final class PotentialRiskViewController: MLBaseViewController  {
    //MARK: View Controller Properties
    var listener: PotentialRiskPresentableListener?
    
    @IBOutlet weak var segementView: MLCommonSegementView! {
        didSet {
            segementView.delegate = self
            let list = ["已发现", "已安排", "已整改", "已验收"]
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
    
    //MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension PotentialRiskViewController: MLUserInterfaceProtocol {
    func queryInformationWithNetwork() {
        
    }
    
    func updateUserInterfaceElements() {
        do {
            let listener = try self.listener.unwrap()
            listener.queryPerilListController()
        } catch { MolueLogger.UIModule.error(error) }
        self.title = "隐患历史"
    }
}

extension PotentialRiskViewController: UIPageViewControllerDelegate {
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

extension PotentialRiskViewController: UIPageViewControllerDataSource {
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return self.selectedIndex > 0 ? self.viewControllers[self.selectedIndex - 1] : nil
    }
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return  self.selectedIndex < self.viewControllers.count - 1 ? self.viewControllers[self.selectedIndex + 1] : nil
    }
}

extension PotentialRiskViewController: PotentialRiskPagePresentable {
    
}

extension PotentialRiskViewController: PotentialRiskViewControllable {
    func setPerilListControllers(with viewControllers: [UIViewController]) {
        self.viewControllers = viewControllers
        let list = [self.viewControllers[self.selectedIndex]]
        self.pageViewController.setViewControllers(list, direction: .forward, animated: false)
        self.segementView.setSelectedItem(at: self.selectedIndex)
    }
}

extension PotentialRiskViewController: MLSegementViewDelegate {
    func segementView(_ segementView: MLCommonSegementView, didSelectItemAt index: Int) {
        self.selectedIndex = index
    }
}
