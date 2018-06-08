//
//  MLCommonPhotoView.swift
//  MolueCommon
//
//  Created by James on 2018/6/7.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import UIKit
enum MLPhoneViewEnum {
    case add
    case normal
}
class MLCommonPhotoView: UIView {
    private var list = [String]()
    @IBOutlet private weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.register(nibWithCellClass: MLCommonPhotoCell.self)
            collectionView.register(nibWithCellClass: MLCommonAddPhotoCell.self)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
}

extension MLCommonPhotoView: UICollectionViewDelegate {
    
}

extension MLCommonPhotoView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: MLCommonPhotoCell.self, for: indexPath)
        return cell!
    }
}
