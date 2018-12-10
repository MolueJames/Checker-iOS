//
//  MLSegementCollectionCell.swift
//  MolueCommon
//
//  Created by MolueJames on 2018/12/10.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import UIKit

class MLSegementCollectionCell: UICollectionViewCell {

    @IBOutlet weak var segementLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    public func refreshSubviews(with title: String) {
        self.segementLabel.text = title
    }
    
    override var isSelected: Bool {
        didSet {
            let color = isSelected ? UIColor(hex: 0x1B82D2) : .lightGray
            self.segementLabel.textColor = color
            let fontSize: CGFloat = isSelected ? 17 : 16
            self.segementLabel.font = .systemFont(ofSize: fontSize)
        }
    }
}
