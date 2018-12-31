//
//  FailureTaskTableViewCell.swift
//  MolueHomePart
//
//  Created by MolueJames on 2018/12/31.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import UIKit
import MolueUtilities
import MolueMediator

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
        }
    }
    
    @IBOutlet weak var taskNameLabel: UILabel!
    
    @IBOutlet weak var remarkLabel: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private var attachments: [MLAttachmentDetail]?
    
    func refreshSubviews(with attachment: MLTaskAttachment) {
        self.remarkLabel.text = attachment.remark ?? "暂无检查备注"
        self.taskNameLabel.text = attachment.content.data()
        self.attachments = attachment.attachments
        let count = attachment.attachments?.count ?? 0
        let height: CGFloat = count == 0 ? 0 : 90
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
