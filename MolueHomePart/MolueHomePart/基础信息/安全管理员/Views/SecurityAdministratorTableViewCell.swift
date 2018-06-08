//
//  AddAdministratorTableViewCell.swift
//  MolueHomePart
//
//  Created by James on 2018/6/4.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import UIKit
import RxSwift
class SecurityAdministratorTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override var frame:CGRect{
        didSet {
            var new = self.frame
            new.origin.x += 10
            new.size.width -= 20
            new.origin.y += 10
            new.size.height -= 15
            super.frame = new
        }
    }
    
    public let detailCommand = PublishSubject<Void>()
    
    public let phoneCommand = PublishSubject<String>()
    
    @IBAction private func detailButtonClicked(_ sender: UIButton) {
        self.detailCommand.onNext(())
    }
    
    @IBAction private func phoneButtonClicked(_ sender: UIButton) {
        self.phoneCommand.onNext("13962624420")
    }
}
