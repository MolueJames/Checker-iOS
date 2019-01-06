//
//  CheckTaskHistoryViewController.swift
//  MolueHomePart
//
//  Created by MolueJames on 2018/11/18.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import UIKit
import MolueUtilities
import MolueCommon
import MolueMediator
import MolueFoundation
import JTAppleCalendar

protocol CheckTaskHistoryPresentableListener: class {
    // 定义一些当前页面需要的业务逻辑, 比如网络请求.
    func jumpToTaskReportController(with indexPath: IndexPath)
    
    func queryCheckTaskHistory(with startDate: Date, endDate: Date)
    
    func queryDailyTaskHistory(with created: Date)
    
    func numberOfRows(in section: Int) -> Int?
    
    func queryDailyTask(with indexPath: IndexPath) -> MLDailyCheckTask?
    
    func queryTaskHistory(with date: Date) -> MLCheckTaskHistory?
}

final class CheckTaskHistoryViewController: MLBaseViewController  {
    //MARK: View Controller Properties
    var listener: CheckTaskHistoryPresentableListener?
    
    @IBOutlet weak var calendarView: JTAppleCalendarView! {
        didSet {
            calendarView.calendarDelegate = self
            calendarView.calendarDataSource = self
            calendarView.register(xibWithCellClass: CheckTaskHistoryCalendarCell.self)
            let kind = UICollectionView.elementKindSectionHeader
            calendarView.register(forKind: kind, withNibClass: CheckTaskHistoryHeaderView.self)
            calendarView.cellSize = MLConfigure.ScreenWidth / 7
            calendarView.minimumInteritemSpacing = 0.5
            calendarView.minimumLineSpacing = 0.5
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
        self.title = date.string(withFormat: "yyyy年MM月")
    }
}

extension CheckTaskHistoryViewController: MLUserInterfaceProtocol {
    func queryInformationWithNetwork() {
    
    }
    
    func updateUserInterfaceElements() {
        self.calendarView.scrollToDate(Date(), animateScroll: false)
    }
}

extension CheckTaskHistoryViewController: CheckTaskHistoryPagePresentable {
    func reloadDailyTaskHistory() {
        self.tableView.reloadData()
    }
    
    func reloadCheckTaskHistory() {
        self.calendarView.reloadData()
    }
}

extension CheckTaskHistoryViewController: CheckTaskHistoryViewControllable {
    
}

extension CheckTaskHistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        do {
            let listener = try self.listener.unwrap()
            let number = listener.numberOfRows(in: section)
            return try number.unwrap()
        } catch { return 0 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: CheckTaskHistoryTableViewCell.self)
        do {
            let listener = try self.listener.unwrap()
            let item = listener.queryDailyTask(with: indexPath)
            try cell.refreshSubviews(with: item.unwrap())
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
            listener.jumpToTaskReportController(with: indexPath)
        } catch { MolueLogger.UIModule.error(error) }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
}

extension CheckTaskHistoryViewController: JTAppleCalendarViewDelegate {
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTAppleCollectionReusableView {
        let kind: String = UICollectionView.elementKindSectionHeader
        return calendar.dequeueReusableSupplementaryView(ofKind: kind, withClass: CheckTaskHistoryHeaderView.self, for: indexPath)
    }
    
    func calendarSizeForMonths(_ calendar: JTAppleCalendarView?) -> MonthSize? {
        return MonthSize(defaultSize: 40)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendarView.dequeueReusableCell(withClass: CheckTaskHistoryCalendarCell.self, for: indexPath)
        cell.refreshSubviews(with: cellState)
        do {
            let listener = try self.listener.unwrap()
            let history = listener.queryTaskHistory(with: date)
            try cell.refreshSubviews(with: history.unwrap())
        } catch {}
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        do {
            let startDate = try visibleDates.monthDates.first.unwrap().date
            let endDate = try visibleDates.monthDates.last.unwrap().date
            self.setupNavigationTitle(date: startDate)
            let listener = try self.listener.unwrap()
            listener.queryCheckTaskHistory(with: startDate, endDate: endDate)
        } catch {
            MolueLogger.UIModule.message(error)
        }
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        do {
            let listener = try self.listener.unwrap()
            listener.queryDailyTaskHistory(with: date)
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        
    }
}

extension CheckTaskHistoryViewController: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let startDate = Date().adding(.year, value: -1)
        return ConfigurationParameters(startDate: startDate, endDate: Date(), numberOfRows: 6, calendar: Calendar.current, generateInDates: .forAllMonths, generateOutDates: .tillEndOfGrid, firstDayOfWeek: .sunday, hasStrictBoundaries: true)
    }
}
