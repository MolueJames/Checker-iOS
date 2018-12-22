//
//  PolicyNoticeTableViewCell.swift
//  MolueHomePart
//
//  Created by MolueJames on 2018/7/6.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import UIKit
import MolueUtilities
import MolueMediator

class PolicyNoticeTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBOutlet weak var createLabel: UILabel!
    @IBOutlet weak var titileLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var updatedLabel: UILabel!
    
    func refreshSubviews(with item: MLPolicyNoticeModel) {
        let updated = self.queryUpdated(with: item)
        self.updatedLabel.text = updated
        let status = self.queryStatus(with: item)
        self.statusLabel.text = status
        let create = self.queryCreate(with: item)
        self.createLabel.text = "发布时间: " + create
        dump(item)
        guard let notification = item.notification else {return}
        self.titileLabel.text = notification.title.data()
    }
    
    func queryUpdated(with item: MLPolicyNoticeModel) -> String {
        if item.signed == true {
            return self.querySigned(with: item)
        }
        if item.readed == true {
           return self.queryReaded(with: item)
        }
        return self.queryCreate(with: item)
    }
    
    func querySigned(with item: MLPolicyNoticeModel) -> String {
        do {
            let signatureTime = try item.signatureTime.unwrap()
            return try signatureTime.transfer(to: "MM-dd")
        } catch {
            return "暂无数据"
        }
    }
    
    func queryReaded(with item: MLPolicyNoticeModel) -> String {
        do {
            let readTime = try item.readTime.unwrap()
            return try readTime.transfer(to: "MM-dd")
        } catch {
            return "暂无数据"
        }
    }
    
    func queryCreate(with item: MLPolicyNoticeModel) -> String {
        do {
            let notification = try item.notification.unwrap()
            let published = try notification.published.unwrap()
            return try published.transfer(to: "MM-dd")
        } catch {
            return "暂无数据"
        }
    }
    
    func queryStatus(with item: MLPolicyNoticeModel) -> String {
        if item.signed == true {return "已签阅"}
        if item.readed == true {return "已阅读"}
        return "未阅读"
    }
}
