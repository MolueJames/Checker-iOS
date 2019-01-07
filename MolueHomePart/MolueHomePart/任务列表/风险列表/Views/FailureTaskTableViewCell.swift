//
//  FailureTaskTableViewCell.swift
//  MolueHomePart
//
//  Created by MolueJames on 2018/12/31.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import UIKit
import RxSwift
import MolueCommon
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
            collectionView.showsHorizontalScrollIndicator = false
        }
    }
    
    private var flowLayout: UICollectionViewFlowLayout! {
        didSet {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumInteritemSpacing = 10
            let width: CGFloat = self.itemHeight - 20
            flowLayout.itemSize = CGSize(width: width, height: width)
            flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        }
    }
    
    private var itemHeight: CGFloat = {
        return (MLConfigure.ScreenWidth - 60) / 3 + 20
    }()
    
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
        let height: CGFloat = count == 0 ? 0 : self.itemHeight
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
