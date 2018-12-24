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

class CheckTaskDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var remarkTitleLabel: UILabel!
    
    @IBOutlet weak var containView: UIView! {
        didSet {
            containView.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var taskNameTop: NSLayoutConstraint!
    
    private var imageList: [UIImage] = [UIImage]()
    
    @IBOutlet weak var statusImageView: UIImageView!
  
    @IBOutlet weak var taskNameLabel: UILabel!
    
    @IBOutlet weak var answerView: UIView!
    
    @IBOutlet weak var additionView: UIView!
    
    @IBOutlet weak var successButton: UIButton!
    
    @IBOutlet weak var failureButton: UIButton!
    
    @IBOutlet weak var detailButton: UIButton!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var collectionHeight: NSLayoutConstraint!
    
    @IBOutlet weak var remarkTitleTop: NSLayoutConstraint!
    @IBOutlet weak var remarkBottom: NSLayoutConstraint!
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
        }
    }
    
    @IBOutlet weak var remarkLabel: UILabel!
    
    @IBAction func successButtonClicked(_ sender: UIButton) {
        self.switchToAddtionView(true)
    }
    
    @IBAction func failureButtonClicked(_ sender: UIButton) {
        self.switchToAddtionView(true)
    }
    
    @IBAction func detailButtonClicked(_ sender: UIButton) {
        
    }
    
    @IBAction func deleteButtonClicked(_ sender: UIButton) {
        self.switchToAddtionView(false)
    }
    
    @IBOutlet weak var collectionTop: NSLayoutConstraint!
    
    private func switchToAddtionView(_ isTo: Bool) {
        self.additionView.isHidden = !isTo
        self.answerView.isHidden = isTo
    }
    
    private var currentIndexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.remarkLabel.text = nil
        self.remarkTitleLabel.text = nil
        self.taskNameTop.constant = 15
        self.collectionHeight.constant = 0
        self.remarkBottom.constant = 0
        self.remarkTitleTop.constant = 0
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func refreshSubviews(with item: MLRiskUnitSolution, indexPath: IndexPath) {
        self.taskNameLabel.text = "\(indexPath.row + 1) " + item.title.data()
        
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
