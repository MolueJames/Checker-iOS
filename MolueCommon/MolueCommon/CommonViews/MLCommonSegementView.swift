//
//  MLCommonSegementView.swift
//  MolueCommon
//
//  Created by MolueJames on 2018/12/10.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import UIKit
import MolueUtilities

public protocol MLSegementViewDelegate: NSObjectProtocol {
    func segementView(_ segementView: MLCommonSegementView, didSelectItemAt index: Int)
}

public struct MLSegementViewConfigure {
    
    public var height: CGFloat = 45
    
    public var bottomColor = UIColor(hex: 0x1B82D2)
}

public class MLCommonSegementView: UIView {
    
    private var configure = MLSegementViewConfigure()
    
    public weak var delegate: MLSegementViewDelegate?

    private var segementLists: [String] = [String]()
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        self.updateViewElements()
    }
    
    private func updateViewElements() {
        self.collectionView.backgroundColor = .white
    }
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.viewFlowLayout)
        collectionView.register(xibWithCellClass: MLSegementCollectionCell.self)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        self.addSubview(collectionView)
        collectionView.snp.makeConstraints({ (make) in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
        })
        return collectionView
    }()
    
    lazy var viewFlowLayout: UICollectionViewFlowLayout = {
        let viewFlowLayout = UICollectionViewFlowLayout()
        viewFlowLayout.scrollDirection = .horizontal
        viewFlowLayout.minimumInteritemSpacing = 0
        viewFlowLayout.minimumLineSpacing = 0
        let width: CGFloat = MLConfigure.ScreenWidth / CGFloat(self.maxCount)
        let height: CGFloat = self.configure.height
        viewFlowLayout.itemSize = CGSize(width: width, height: height)
        return viewFlowLayout
    }()
    
    lazy var bottomView: UIView = {
        let originY: CGFloat = self.configure.height - 2
        let frame = CGRect(x: 0, y: originY, width: 65, height: 2)
        let bottomView = UIView(frame: frame)
        self.addSubview(bottomView)
        let color = self.configure.bottomColor
        bottomView.backgroundColor = color
        return bottomView
    }()
    
    private var maxCount: Int {
        let isMax = self.segementLists.count > 5
        return isMax ? 5 : self.segementLists.count
    }
    
    public func updateSegementList(with list: [String]) {
        self.segementLists = list
        self.collectionView.reloadData()
        let indexPath = IndexPath(row: 0, section: 0)
        self.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .bottom)
        let width = MLConfigure.ScreenWidth / CGFloat(self.maxCount)
        self.bottomView.centerX = width / 2
    }
    
    public func updateViewConfigure(with configure: MLSegementViewConfigure) {
        self.bottomView.backgroundColor = configure.bottomColor
        let width: CGFloat = MLConfigure.ScreenWidth / CGFloat(self.maxCount)
        let height: CGFloat = configure.height
        self.viewFlowLayout.itemSize = CGSize(width: width, height: height)
        self.configure = configure;
    }
}

extension MLCommonSegementView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        do {
            let cell = try collectionView.cellForItem(at: indexPath).unwrap()
            self.doCellSelectedAnimation(with: cell)
            let delegate = try self.delegate.unwrap()
            delegate.segementView(self, didSelectItemAt: indexPath.row)
        } catch { MolueLogger.UIModule.message(error) }
    }
    
    private func doCellSelectedAnimation(with selectedCell: UICollectionViewCell) {
        UIView .animate(withDuration: 0.4) {
            self.bottomView.centerX = selectedCell.centerX
            selectedCell.isSelected = true
        }
    }
}

extension MLCommonSegementView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.maxCount
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: MLSegementCollectionCell.self, for: indexPath)
        do {
            let item = self.segementLists.item(at: indexPath.row)
            try cell.refreshSubviews(with: item.unwrap())
        } catch { MolueLogger.UIModule.message(error) }
        return cell
    }
}
