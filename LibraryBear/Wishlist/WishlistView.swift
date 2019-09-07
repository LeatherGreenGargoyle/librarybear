//
//  WishlistView.swift
//  LibraryBear
//
//  Created by Andrew Tran on 9/4/19.
//  Copyright © 2019 Andrew Tran. All rights reserved.
//

import Foundation
import SnapKit
import UIKit

class WishListView: UIView {
    // MARK: Subviews
    private let header: UILabel = {
        let label = UILabel()
        label.text = "I am the WishlistView"
        label.font = .regular14
        return label
    }()
    let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubviews([header, collectionView])
        header.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
        }
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(header.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
