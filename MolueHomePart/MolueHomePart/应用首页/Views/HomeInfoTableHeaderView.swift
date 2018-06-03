//
//  HomeInfoTableHeaderView.swift
//  MolueHomePart
//
//  Created by James on 2018/5/13.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import UIKit
import RxSwift
import SnapKit
import MolueUtilities
class HomeInfoTableHeaderView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.register(xibWithCellClass: HomeInfoCollectionViewCell.self)
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.scrollDirection = .horizontal
            let width = MLConfigure.screenWidth - 30
            flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            flowLayout.itemSize = CGSize(width: width, height: 180)
            collectionView.collectionViewLayout = flowLayout
        }
    }
    
    @IBOutlet private weak var basicInfoView: UIView!
    
    @IBOutlet private weak var riskCheckView: UIView!
    
    private func addControlToRiskCheckView() {
        let control = UIControl.init()
        riskCheckView.addSubview(control)
        control.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        control.addTarget(self, action: #selector(riskCheckControlClicked), for: .touchUpInside)
    }
    
    private func addControlToBasicInfoView() {
        let control = UIControl.init()
        basicInfoView.addSubview(control)
        control.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        control.addTarget(self, action: #selector(basicInfoControlClicked), for: .touchUpInside)
    }
    
    private func addControlsToBottomView() {
        self.addControlToNotificationView()
        self.addControlToEducationView()
        self.addControlToLegislationView()
        self.addControlToDataRecordView()
    }
    
    private func addControlToNotificationView () {
        let control = UIControl.init()
        notificationView.addSubview(control)
        control.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        control.addTarget(self, action: #selector(notificationControlClicked), for: .touchUpInside)
    }
    
    private func addControlToEducationView() {
        let control = UIControl.init()
        educationView.addSubview(control)
        control.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        control.addTarget(self, action: #selector(educationControlClicked), for: .touchUpInside)
    }
    
    private func addControlToLegislationView() {
        let control = UIControl.init()
        legislationView.addSubview(control)
        control.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        control.addTarget(self, action: #selector(legislationControlClicked), for: .touchUpInside)
    }
    
    private func addControlToDataRecordView() {
        let control = UIControl.init()
        dataRecordView.addSubview(control)
        control.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        control.addTarget(self, action: #selector(dataRecordControlClicked), for: .touchUpInside)
    }
    
    @IBAction private func basicInfoControlClicked(_ sender: Any) {
        self.basicInfoCommand.onNext(())
    }
    @IBAction private func riskCheckControlClicked(_ sender: Any) {
        self.riskCheckCommand.onNext(())
    }
    @IBAction private func dataRecordControlClicked(_ sender: Any) {
        self.dataRecordCommand.onNext(())
    }
    @IBAction private func legislationControlClicked(_ sender: Any) {
        self.legislationCommand.onNext(())
    }
    @IBAction private func educationControlClicked(_ sender: Any) {
        self.educationCommand.onNext(())
    }
    @IBAction private func notificationControlClicked(_ sender: Any) {
        self.notificationCommand.onNext(())
    }
    
    @IBOutlet private weak var bottomView: UIView! {
        didSet {
            bottomView.layer.cornerRadius = 6
            bottomView.layer.masksToBounds = true
        }
    }
    
    @IBOutlet private weak var notificationView: UIView!
    @IBOutlet private weak var educationView: UIView!
    @IBOutlet private weak var legislationView: UIView!
    @IBOutlet private weak var dataRecordView: UIView!
    
    let selectedCommand = PublishSubject<String>()
    /// 基础信息
    let basicInfoCommand = PublishSubject<Void>()
    /// 隐患自查
    let riskCheckCommand = PublishSubject<Void>()
    /// 政策通知
    let notificationCommand = PublishSubject<Void>()
    /// 教育培训
    let educationCommand = PublishSubject<Void>()
    /// 法律法规
    let legislationCommand = PublishSubject<Void>()
    /// 资料备案
    let dataRecordCommand = PublishSubject<Void>()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addControlToBasicInfoView()
        self.addControlToRiskCheckView()
        self.addControlsToBottomView()
    }
}

extension HomeInfoTableHeaderView: UICollectionViewDelegate {

}

extension HomeInfoTableHeaderView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:HomeInfoCollectionViewCell! = collectionView.dequeueReusableCell(withClass: HomeInfoCollectionViewCell.self, for: indexPath)
        return cell
    }
}
