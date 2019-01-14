//
//  HomeInfoTableHeaderView.swift
//  MolueHomePart
//
//  Created by James on 2018/5/13.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import UIKit
import MolueUtilities
import MolueMediator
import RxSwift
import SnapKit

class HomeInfoTableHeaderView: UIView {
    
    private var advertisement = [MLAdvertisement]()
    
    func refreshBannerList(with advertisement: [MLAdvertisement]) {
        self.advertisement = advertisement
        self.collectionView.reloadData()
    }

    @IBOutlet private weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.register(xibWithCellClass: HomeInfoCollectionViewCell.self)
            self.flowLayout = UICollectionViewFlowLayout()
            collectionView.collectionViewLayout = self.flowLayout
        }
    }
    
    private var flowLayout: UICollectionViewFlowLayout! {
        didSet {
            flowLayout.scrollDirection = .horizontal
            let width = MLConfigure.ScreenWidth - 30
            flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            flowLayout.itemSize = CGSize(width: width, height: 180)
        }
    }
    
    @IBOutlet private weak var basicInfoView: UIView! {
        didSet {
            let control = UIControl.init()
            basicInfoView.doBespreadOn(control)
            control.addTarget(self, action: #selector(basicInfoControlClicked), for: .touchUpInside)
        }
    }
    
    @IBOutlet private weak var riskCheckView: UIView! {
        didSet {
            let control = UIControl.init()
            riskCheckView.doBespreadOn(control)
            control.addTarget(self, action: #selector(riskCheckControlClicked), for: .touchUpInside)
        }
    }
    
    @IBAction private func basicInfoControlClicked(_ sender: Any) {
        self.dailyTaskCommand.onNext(())
    }
    @IBAction private func riskCheckControlClicked(_ sender: Any) {
        self.riskCheckCommand.onNext(())
    }
    @IBAction private func dangerListControlClicked(_ sender: Any) {
        self.dangerListCommand.onNext(())
    }
    @IBAction private func legislationControlClicked(_ sender: Any) {
        self.legislationCommand.onNext(())
    }
    @IBAction private func riskHistoryControlClicked(_ sender: Any) {
        self.riskHistoryCommand.onNext(())
    }
    @IBAction private func notificationControlClicked(_ sender: Any) {
        self.notificationCommand.onNext(())
    }
    
    @IBOutlet private weak var notificationView: UIView! {
        didSet {
            let control = UIControl.init()
            notificationView.doBespreadOn(control)
            control.addTarget(self, action: #selector(notificationControlClicked), for: .touchUpInside)
        }
    }
    @IBOutlet private weak var riskHistoryView: UIView! {
        didSet {
            let control = UIControl.init()
            riskHistoryView.doBespreadOn(control)
            control.addTarget(self, action: #selector(riskHistoryControlClicked), for: .touchUpInside)
        }
    }
    @IBOutlet private weak var legislationView: UIView! {
        didSet {
            let control = UIControl.init()
            legislationView.doBespreadOn(control)
            control.addTarget(self, action: #selector(legislationControlClicked), for: .touchUpInside)
        }
    }
    @IBOutlet private weak var dangerListView: UIView! {
        didSet {
            let control = UIControl.init()
            dangerListView.doBespreadOn(control)
            control.addTarget(self, action: #selector(dangerListControlClicked), for: .touchUpInside)
        }
    }
    
    var selectedCommand = PublishSubject<String>()
    /// 基础信息
    var dailyTaskCommand = PublishSubject<Void>()
    /// 隐患自查
    var riskCheckCommand = PublishSubject<Void>()
    /// 政策通知
    var notificationCommand = PublishSubject<Void>()
    /// 法律法规
    var legislationCommand = PublishSubject<Void>()
    /// 检查历史
    var dangerListCommand = PublishSubject<Void>()
    /// 隐患历史
    var riskHistoryCommand = PublishSubject<Void>()
}

extension HomeInfoTableHeaderView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension HomeInfoTableHeaderView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.advertisement.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: HomeInfoCollectionViewCell.self, for: indexPath)
        return cell
    }
}
