//
//  AddProblemCollectionViewCell.swift
//  MolueRiskPart
//
//  Created by MolueJames on 2019/1/24.
//  Copyright © 2019 MolueTech. All rights reserved.
//

import UIKit

class AddProblemCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func refreshSubviews(with problem: String) {
        self.titleLabel.text = problem
    }
}
