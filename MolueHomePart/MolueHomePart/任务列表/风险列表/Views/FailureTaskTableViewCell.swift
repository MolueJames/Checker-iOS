//
//  FailureTaskTableViewCell.swift
//  MolueHomePart
//
//  Created by MolueJames on 2018/12/31.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import UIKit
import RxSwift
import MolueUtilities
import MolueMediator

typealias FailureAttachment = (MLTaskAttachment, IndexPath)

class FailureTaskTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.register(xibWithCellClass: TaskAttachmentCollectionCell.self)
            self.flowLayout = UICollectionViewFlowLayout()
            collectionView.collectionViewLayout = self.flowLayout
        }
    }
    
    private var flowLayout: UICollectionViewFlowLayout! {
        didSet {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumInteritemSpacing = 10
            flowLayout.itemSize = CGSize(width: 80, height: 80)
            flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        }
    }
    
    @IBOutlet weak var taskNameLabel: UILabel!
    
    @IBOutlet weak var remarkLabel: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private var taskAttachment: MLTaskAttachment?
    
    private var currentIndexPath: IndexPath?
    
    private var attachments: [MLAttachmentDetail]?
    
    public var riskCommand: PublishSubject<FailureAttachment>?
    
    func refreshSubviews(with attachment: MLTaskAttachment, indexPath: IndexPath) {
        self.updateSubviewsLayout(with: attachment)
        self.riskCommand = PublishSubject<FailureAttachment>()
        self.currentIndexPath = indexPath
        self.taskAttachment = attachment
    }
    
    @IBAction func insertButtonClicked(_ sender: UIButton) {
        do {
            let indexPath = try self.currentIndexPath.unwrap()
            let attachment = try self.taskAttachment.unwrap()
            let riskCommand = try self.riskCommand.unwrap()
            riskCommand.onNext((attachment, indexPath))
        } catch {
            MolueLogger.UIModule.message(error)
        }
    }
    
    private func updateSubviewsLayout(with attachment: MLTaskAttachment) {
        self.remarkLabel.text = attachment.remark ?? "暂无检查备注"
        self.taskNameLabel.text = attachment.content.data()
        self.attachments = attachment.attachments
        let count = attachment.attachments?.count ?? 0
        let height: CGFloat = count == 0 ? 0 : 100
        self.collectionViewHeight.constant = height
        self.collectionView.reloadData()
    }
}

extension FailureTaskTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        do {
            return try self.attachments.unwrap().count
        } catch { return 0 }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: TaskAttachmentCollectionCell.self, for: indexPath)
        do {
            let attachments = try self.attachments.unwrap()
            let item = attachments.item(at: indexPath.row)
            try cell.loadAttachmentURL(with: item.unwrap())
        } catch {
            MolueLogger.UIModule.message(error)
        }
        return cell
    }
}

extension FailureTaskTableViewCell: UICollectionViewDelegate {
    
}
