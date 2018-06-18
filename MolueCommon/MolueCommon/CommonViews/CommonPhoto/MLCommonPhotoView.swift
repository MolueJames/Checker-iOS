//
//  MLCommonPhotoView.swift
//  MolueCommon
//
//  Created by James on 2018/6/7.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import UIKit
import RxSwift
import MolueUtilities
fileprivate enum MLPhotoMethodEnum {
    case append
    case normal
    static func whichOne(_ section: Int) -> MLPhotoMethodEnum {
        return section == 0 ? .normal : .append
    }
}

public class MLCommonPhotoView: UIView {
    private var list = [UIImage]()

    private var limitCount = 9
    
    private let disposeBag = DisposeBag()
    
    public let appendCommand = PublishSubject<Int>()
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.register(xibWithCellClass: MLCommonPhotoCell.self)
            collectionView.register(xibWithCellClass: MLCommonAddPhotoCell.self)
            self.flowLayout = UICollectionViewFlowLayout()
            collectionView.collectionViewLayout = self.flowLayout
        }
    }
    private var flowLayout: UICollectionViewFlowLayout! {
        didSet {
            flowLayout.scrollDirection = .horizontal
            flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 0)
            flowLayout.itemSize = CGSize(width: 80, height: 80)
        }
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func defaultValue(title: String, list: [UIImage], count: Int) {
        self.titleLabel.text = title
        self.limitCount = count
        self.list = list
    }
    
    public func appendImages(_ images: [UIImage]) {
        objc_sync_enter(self)
        defer {objc_sync_exit(self)}
        self.list = self.list + images
        self.collectionView.reloadData()
    }
}

extension MLCommonPhotoView: UICollectionViewDelegate {
    
}

extension MLCommonPhotoView: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? list.count : 1
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch MLPhotoMethodEnum.whichOne(indexPath.section) {
        case .append:
            let cell: MLCommonAddPhotoCell! = collectionView.dequeueReusableCell(withClass: MLCommonAddPhotoCell.self, for: indexPath)
            self.handleAddPhotoCell(cell, indexPath: indexPath)
            return cell
        case .normal:
            let cell: MLCommonPhotoCell! = collectionView.dequeueReusableCell(withClass: MLCommonPhotoCell.self, for: indexPath)
            self.handelShowPhotoCell(cell, indexPath: indexPath)
            return cell
        }
    }
    
    private func handleAddPhotoCell(_ cell: MLCommonAddPhotoCell, indexPath: IndexPath) {
        cell.appendCommand.subscribe(onNext: { [unowned self] (_) in
            let leftCount = self.limitCount - self.list.count
            self.appendCommand.onNext(leftCount)
        }).disposed(by: disposeBag)
    }
    
    private func handelShowPhotoCell(_ cell: MLCommonPhotoCell, indexPath: IndexPath) {
        let image = self.list[indexPath.row]
        cell.reloadSubviewWithImage(image)
        cell.deleteCommand.subscribe(onNext: { [unowned self] (_) in
            objc_sync_enter(self)
            defer {objc_sync_exit(self)}
            self.doDeleteOperationForCell(cell)
        }).disposed(by: disposeBag)
    }
    
    private func doDeleteOperationForCell(_ cell: MLCommonPhotoCell) {
        guard let path = self.collectionView.indexPath(for: cell) else {
            MolueLogger.UIModule.error("the indexPath is not existed"); return
        }
        self.collectionView.performBatchUpdates({
            self.list.remove(at: path.row)
            self.collectionView.deleteItems(at: [path])
        })
    }
}
