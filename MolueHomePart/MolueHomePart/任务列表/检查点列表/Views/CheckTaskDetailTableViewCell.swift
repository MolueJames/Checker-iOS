//
//  CheckTaskDetailTableViewCell.swift
//  MolueHomePart
//
//  Created by MolueJames on 2018/11/10.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import UIKit
import MolueMediator
import MolueUtilities

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
            collectionView.dataSource = self
            collectionView.delegate = self
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
        self.statusLabel.isHidden = true
        self.remarkLabel.text = nil
        self.remarkTitleLabel.text = nil
        self.collectionHeight.constant = 0
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func refreshSubviews(with item: MLRiskUnitSolution, indexPath: IndexPath) {
        self.taskNameLabel.text = "\(indexPath.row + 1), " + item.title.data()
        self.updateAnswerButton(with: item)
        self.updateAttachment(with: item)
        self.selectedIndexPath = indexPath
    }
    
    private func updateAnswerButton(with solution: MLRiskUnitSolution) {
        do {
            let answers = try solution.answers.unwrap()
            let answerList = answers.components(separatedBy: ",")
            for title in answerList {
                if (title == solution.rightAnswer) {
                    self.successButton.setTitle(title, for: .normal)
                } else {
                    self.failureButton.setTitle(title, for: .normal)
                }
            }
        } catch { MolueLogger.UIModule.message(error) }
    }
    
    private func updateAttachment(with solution: MLRiskUnitSolution) {
        self.attachment?.rightAnswer = solution.rightAnswer
        self.attachment?.answers = solution.answers
    }
}

extension CheckTaskDetailTableViewCell: UICollectionViewDelegate {
    
}

extension CheckTaskDetailTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}
