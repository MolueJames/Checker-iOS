//
//  TaskCheckReportTableViewCell.swift
//  MolueHomePart
//
//  Created by JamesCheng on 2018-12-24.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import UIKit
import MolueCommon
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
            collectionView.showsHorizontalScrollIndicator = false
        }
    }
    
    private lazy var itemHeight: CGFloat = {
        return (MLConfigure.ScreenWidth - 60) / 3 + 10
    }()
    
    private var flowLayout: UICollectionViewFlowLayout! {
        didSet {
            flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 10, right: 20)
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumInteritemSpacing = 10
            let width: CGFloat = self.itemHeight - 10
            flowLayout.itemSize = CGSize(width: width, height: width)
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
        let height: CGFloat = count == 0 ? 0 : self.itemHeight
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.jumpToBrowserController(with: indexPath.row)
    }
    
    func jumpToBrowserController(with index: Int) {
        do {
            let attachments = try self.attachments.unwrap()
            let photoURLs = self.createPhotoURLs(with: attachments)
            SKPhotoBrowserOptions.displayDeleteButton = false
            let browser = SKPhotoBrowser(photos: photoURLs)
            browser.initializePageIndex(index)
            MoluePageNavigator.shared.presentViewController(browser)
        } catch { MolueLogger.UIModule.message(error) }
    }
    
    private func createPhotoURLs(with attachments: [MLAttachmentDetail]) -> [KFPhoto] {
        return attachments.compactMap { attachment in
            do {
                let urlPath = try attachment.urlPath.unwrap()
                return KFPhoto(url: urlPath)
            } catch {
                return MolueLogger.UIModule.allowNil(error)
            }
        }
    }
}
