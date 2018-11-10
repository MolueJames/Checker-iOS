//
//  PotentialRiskHeaderView.swift
//  MolueRiskPart
//
//  Created by MolueJames on 2018/11/10.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import UIKit

class PotentialRiskHeaderView: UIView {

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
            flowLayout.itemSize = CGSize(width: 78, height: 78)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.init(hex: 0x1B82D2)
    }
}

extension PotentialRiskHeaderView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: PotentialRiskCollectionCell.self, for: indexPath)
        return cell
    }
}

extension PotentialRiskHeaderView: UICollectionViewDelegate {
    
}
