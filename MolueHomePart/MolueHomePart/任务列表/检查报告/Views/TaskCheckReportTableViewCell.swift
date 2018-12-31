//
//  TaskCheckReportTableViewCell.swift
//  MolueHomePart
//
//  Created by JamesCheng on 2018-12-24.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import UIKit
import MolueUtilities
import MolueMediator

class TaskCheckReportTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var remarkLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
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
            flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 10, right: 20)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private var attachments: [MLAttachmentDetail]?
    
    func refreshSubviews(with attachment: MLTaskAttachment) {
        self.statusLabel.text = attachment.result.data()
        let isRight = attachment.result == attachment.rightAnswer
        let color = isRight ? UIColor(hex: 0x009966) : UIColor(hex: 0xFF0000)
        self.statusLabel.backgroundColor = color
        self.remarkLabel.text = attachment.remark ?? "暂无检查备注"
        self.contentLabel.text = attachment.content.data()
        self.attachments = attachment.attachments
        let count = attachment.attachments?.count ?? 0
        let height: CGFloat = count == 0 ? 0 : 90
        self.collectionViewHeight.constant = height
        self.collectionView.reloadData()
    }
}

extension TaskCheckReportTableViewCell: UICollectionViewDataSource {
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

extension TaskCheckReportTableViewCell: UICollectionViewDelegate {
    
}
