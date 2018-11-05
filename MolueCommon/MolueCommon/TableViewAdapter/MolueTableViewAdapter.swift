//
//  MLTableViewAdapter.swift
//  MolueCommon
//
//  Created by MolueJames on 2018/10/2.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import Foundation
import MolueUtilities

open class MLTableViewAdapter<T: UITableViewCell, U>: NSObject, UITableViewDataSource, UITableViewDelegate {
    private var tableView: UITableView!
    private var valueList: [U]
    private var rowHeights = [CGFloat]()
    private var heightForEachRow: CGFloat = 44.0
    
    private var cellForRowAt: ((IndexPath, T, U) -> Void)?
    private var heightForRowAt: ((IndexPath, U) -> CGFloat)?
    private var didSelectRowAt: ((IndexPath, U) -> Void)?
    
    public init(with valueList: [U]) {
        self.valueList = valueList
    }
    //MARK: Table View Data Source
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return valueList.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: T.self)
        do {
            let item = self.valueList.item(at: indexPath.row)
            let cellForRowAt = try self.cellForRowAt.unwrap()
            try cellForRowAt(indexPath, cell, item.unwrap())
        } catch {
            MolueLogger.UIModule.error(error)
        }
        return cell
    }
    //MARK: Table View Delegate
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        do {
            let item = self.valueList.item(at: indexPath.row)
            let heightForRowAt = try self.heightForRowAt.unwrap()
            return try heightForRowAt(indexPath, item.unwrap())
        } catch {}
        return self.heightForEachRow
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        do {
            let item = self.valueList.item(at: indexPath.row)
            let didSelectRowAt = try self.didSelectRowAt.unwrap()
            try didSelectRowAt(indexPath, item.unwrap())
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
}
public extension MLTableViewAdapter {
    public func reload(with valueList:[U]) {
        self.valueList = valueList
        self.tableView.reloadData()
    }
    
    public func append(with item: U) {
        self.valueList.append(item)
        self.tableView.reloadData()
    }
    
    public func append(with items: [U]) {
        self.valueList.append(contentsOf: items)
        self.tableView.reloadData()
    }
    
    public func remove(at index: Int) {
        self.valueList.remove(at: index)
        self.tableView.reloadData()
    }
    
    public func removeAll(where predicate: (U) throws -> Bool) rethrows {
        try self.valueList.removeAll(where: predicate)
        self.tableView.reloadData()
    }
}

public extension MLTableViewAdapter {
    public func bindingTableView(_ tableView: UITableView) {
        self.tableView = tableView
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(xibWithCellClass: T.self)
    }
    
    public func heightForEachRow(_ height: CGFloat) {
        self.heightForEachRow = height
    }
    
    public func cellForRowAtClosure(_ cellForRowAt: @escaping (IndexPath, T, U) -> Void) {
        self.cellForRowAt = cellForRowAt
    }
    
    public func heightForRowAtClosure(_ heightForRowAt: @escaping (IndexPath, U) -> CGFloat) {
        self.heightForRowAt = heightForRowAt
    }
    
    public func didSelectRowAtClosure(_ didSelectRowAt: @escaping ((IndexPath, U) -> Void)) {
        self.didSelectRowAt = didSelectRowAt
    }
}
