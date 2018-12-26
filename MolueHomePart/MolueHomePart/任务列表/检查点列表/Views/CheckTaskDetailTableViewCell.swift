//
//  CheckTaskDetailTableViewCell.swift
//  MolueHomePart
//
//  Created by MolueJames on 2018/11/10.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import UIKit
import MolueUtilities
import MolueMediator

typealias AttachmentClosure = (_ item: MLTaskAttachment, _ indexPath: IndexPath) -> Void

class CheckTaskDetailTableViewCell: UITableViewCell {
    
    public var detailClosure: AttachmentClosure?
    
    public var updateClosure: AttachmentClosure?
    
    @IBOutlet weak var remarkTitleLabel: UILabel!
    
    @IBOutlet weak var containView: UIView! {
        didSet {
            containView.layer.cornerRadius = 5
            containView.layer.masksToBounds = true
        }
    }
    
    private var imageList: [UIImage] = [UIImage]()
    
    @IBOutlet weak var statusLabel: UILabel!
  
    @IBOutlet weak var taskNameLabel: UILabel!
    
    @IBOutlet weak var answerView: UIView!
    
    @IBOutlet weak var additionView: UIView!
    
    @IBOutlet weak var successButton: UIButton!
    
    @IBOutlet weak var failureButton: UIButton!
    
    @IBOutlet weak var collectionHeight: NSLayoutConstraint!
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(xibWithCellClass: TaskAttachmentCollectionCell.self)
            collectionView.dataSource = self
            collectionView.delegate = self
            self.flowLayout = UICollectionViewFlowLayout()
            collectionView.collectionViewLayout = self.flowLayout
        }
    }
    
    private var flowLayout: UICollectionViewFlowLayout! {
        didSet {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumInteritemSpacing = 10
            flowLayout.itemSize = CGSize(width: 50, height: 50)
            flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        }
    }
    
    @IBOutlet weak var remarkLabel: UILabel!
    
    @IBAction func successButtonClicked(_ sender: UIButton) {
        self.switchToAddtionView(true)
        self.updateStatusLabel(with: sender)
        
    }
    
    @IBAction func failureButtonClicked(_ sender: UIButton) {
        self.switchToAddtionView(true)
        self.updateStatusLabel(with: sender)
    }
    
    private func updateStatusLabel(with button: UIButton) {
        let color = button.backgroundColor
        self.statusLabel.backgroundColor = color
        
        self.statusLabel.isHidden = false
        let title = button.titleLabel?.text
        self.statusLabel.text = title
        self.attachment?.result = title
        
        do {
            let updateClosure = try self.updateClosure.unwrap()
            let attachment = try self.attachment.unwrap()
            let indexPath = try self.selectedIndexPath.unwrap()
            updateClosure(attachment, indexPath)
        } catch {
            MolueLogger.UIModule.message(error)
        }
    }
    
    @IBAction func detailButtonClicked(_ sender: UIButton) {
        do {
            let detailClosure = try self.detailClosure.unwrap()
            let attachment = try self.attachment.unwrap()
            let indexPath = try self.selectedIndexPath.unwrap()
            detailClosure(attachment, indexPath)
        } catch {
            MolueLogger.UIModule.message(error)
        }
    }
    
    @IBAction func deleteButtonClicked(_ sender: UIButton) {
        self.switchToAddtionView(false)
        self.statusLabel.isHidden = true
    }
    
    @IBOutlet weak var collectionTop: NSLayoutConstraint!
    
    private func switchToAddtionView(_ isTo: Bool) {
        self.additionView.isHidden = !isTo
        self.answerView.isHidden = isTo
    }
    
    private var selectedIndexPath: IndexPath?
    
    public var attachment: MLTaskAttachment?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func refreshSubviews(with attachment: MLTaskAttachment, indexPath: IndexPath) {
        self.attachment = attachment
        self.updateSubviewsLayout(with: attachment)
        self.updateAnswerButton(with: attachment)
        self.selectedIndexPath = indexPath
    }
    
    private func updateSubviewsLayout(with attachment: MLTaskAttachment) {
        self.taskNameLabel.text = attachment.content.data()
        
        let constant:CGFloat = numberOfItems() == 0 ? 0 : 70
        self.collectionHeight.constant = constant
        self.collectionView.reloadData()
        
        self.remarkLabel.text = attachment.remark
        let title = attachment.remark.isSome() ? "备注:" : nil
        self.remarkTitleLabel.text = title
    }
    
    private func updateAnswerButton(with attachmetn: MLTaskAttachment) {
        do {
            let answers = try attachmetn.answers.unwrap()
            let answerList = answers.components(separatedBy: ",")
            for title in answerList {
                if (title == attachmetn.rightAnswer) {
                    self.successButton.setTitle(title, for: .normal)
                } else {
                    self.failureButton.setTitle(title, for: .normal)
                }
            }
        } catch { MolueLogger.UIModule.message(error) }
    }
    
}

extension CheckTaskDetailTableViewCell: UICollectionViewDelegate {
    
}

extension CheckTaskDetailTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.numberOfItems()
    }
    
    private func numberOfItems() -> Int {
        do {
            let attachment = try self.attachment.unwrap()
            return try attachment.attachments.unwrap().count
        } catch { return 0 }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: TaskAttachmentCollectionCell.self, for: indexPath)
        do {
            let attachment = try self.attachment.unwrap()
            let details = try attachment.attachments.unwrap()
            let item = try details.item(at: indexPath.row).unwrap()
            cell.refreshSubviews(with: item)
        } catch {
            MolueLogger.UIModule.message(error)
        }
        return cell
    }
}
