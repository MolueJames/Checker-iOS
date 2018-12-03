//
//  CheckTaskHistoryViewController.swift
//  MolueHomePart
//
//  Created by MolueJames on 2018/11/18.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import UIKit
import MolueUtilities
import MolueMediator
import MolueFoundation
import JTAppleCalendar

protocol CheckTaskHistoryPresentableListener: class {
    // 定义一些当前页面需要的业务逻辑, 比如网络请求.
    var valueList: [DangerUnitRiskModel] {get}
    
    func jumpToTaskHistoryController(with item: DangerUnitRiskModel)
}

final class CheckTaskHistoryViewController: MLBaseViewController  {
    //MARK: View Controller Properties
    var listener: CheckTaskHistoryPresentableListener?
    
    @IBOutlet weak var calendarView: JTAppleCalendarView! {
        didSet {
            calendarView.calendarDelegate = self
            calendarView.calendarDataSource = self
            calendarView.register(xibWithCellClass: CheckTaskHistoryCalendarCell.self)
            
        }
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(xibWithCellClass: CheckTaskHistoryTableViewCell.self)
        }
    }
    //MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func setupNavigationTitle(date: Date) {
        self.title = date.string(withFormat: "yyyy MMM")
    }
}

extension CheckTaskHistoryViewController: MLUserInterfaceProtocol {
    func queryInformationWithNetwork() {
        dump(self.calendarView.visibleDates())
        self.calendarView.visibleDates { (visibleDate: DateSegmentInfo) in
            dump(visibleDate)
        }
    }
    
    func updateUserInterfaceElements() {
//        self.setupNavigationTitle(date: Date())
        self.calendarView.scrollToDate(Date(), animateScroll: false)
    }
}

extension CheckTaskHistoryViewController: CheckTaskHistoryPagePresentable {
    
}

extension CheckTaskHistoryViewController: CheckTaskHistoryViewControllable {
    
}

extension CheckTaskHistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        do {
            let listener = try self.listener.unwrap()
            return listener.valueList.count
        } catch { return 0 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: CheckTaskHistoryTableViewCell.self)
        do {
            let listener = try self.listener.unwrap()
            let item = try listener.valueList.item(at: indexPath.row).unwrap()
            cell.refreshSubviews(with: item)
        } catch {
            MolueLogger.UIModule.error(error)
        }
        return cell
    }
}

extension CheckTaskHistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        do {
            let listener = try self.listener.unwrap()
            let item = try listener.valueList.item(at: indexPath.row).unwrap()
            listener.jumpToTaskHistoryController(with: item)
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
}

extension CheckTaskHistoryViewController: JTAppleCalendarViewDelegate {
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendarView.dequeueReusableCell(withClass: CheckTaskHistoryCalendarCell.self, for: indexPath)
        cell.refreshSubviews(with: cellState, model: "")
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupNavigationTitle(date: visibleDates.monthDates.first!.date)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        
    }
}

extension CheckTaskHistoryViewController: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let startDate = Date().adding(.year, value: -1)
        return ConfigurationParameters(startDate: startDate, endDate: Date(), numberOfRows: 6, calendar: Calendar.current, generateInDates: .forAllMonths, generateOutDates: .off, firstDayOfWeek: .sunday, hasStrictBoundaries: true)
    }
}
