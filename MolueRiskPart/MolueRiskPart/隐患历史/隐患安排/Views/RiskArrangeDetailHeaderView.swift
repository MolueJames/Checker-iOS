//
//  PotentialRiskHeaderView.swift
//  MolueRiskPart
//
//  Created by MolueJames on 2018/11/10.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import MolueMediator
import MolueUtilities
import UIKit

class RiskArrangeDetailHeaderView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBOutlet weak var riskDescriptionLabel: UILabel!
    
    func refreshSubviews(with model: String) {
        self.riskDescriptionLabel.text = model
    }
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.register(xibWithCellClass: PotentialRiskCollectionCell.self)
            self.flowLayout = UICollectionViewFlowLayout()
            collectionView.collectionViewLayout = self.flowLayout
        }
    }
    
    private var flowLayout: UICollectionViewFlowLayout! {
        didSet {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumInteritemSpacing = 10
            flowLayout.sectionInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
            flowLayout.itemSize = CGSize(width: 80, height: 80)
        }
    }
    private var hiddenPeril: MLHiddenPerilItem?
    
    func refreshSubviews(with hiddenPeril: MLHiddenPerilItem)  {
        self.hiddenPeril = hiddenPeril
        self.collectionView.reloadData()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.init(hex: 0x1B82D2)
    }
}

extension RiskArrangeDetailHeaderView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        do {
            let hiddenPeril = try self.hiddenPeril.unwrap()
            let attachments = try hiddenPeril.attachments.unwrap()
            return attachments.count
        } catch { return 0 }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: PotentialRiskCollectionCell.self, for: indexPath)
        do {
            let hiddenPeril = try self.hiddenPeril.unwrap()
            let attachments = try hiddenPeril.attachments.unwrap()
            let item = attachments.item(at: indexPath.row)
            try cell.refreshSubviews(with: item.unwrap())
        } catch { MolueLogger.UIModule.message(error) }
        return cell
    }
}

extension RiskArrangeDetailHeaderView: UICollectionViewDelegate {
    
}
