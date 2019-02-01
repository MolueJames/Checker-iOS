//
//  AddProblemCollectionFooterView.swift
//  MolueRiskPart
//
//  Created by MolueJames on 2019/1/27.
//  Copyright © 2019 MolueTech. All rights reserved.
//

import UIKit
import RxSwift

class AddProblemResuableFooterView: UICollectionReusableView {
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var submitButton: UIButton! {
        didSet {
            submitButton.layer.cornerRadius = 3
        }
    }
    public var submitCommand = PublishSubject<Void>()
    
    @IBAction func submitButtonClicked(_ sender: UIButton) {
        self.submitCommand.onNext(())
    }
}
