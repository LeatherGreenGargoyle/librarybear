//
//  SearchView.swift
//  LibraryBear
//
//  Created by Andrew Tran on 9/4/19.
//  Copyright © 2019 Andrew Tran. All rights reserved.
//

import Foundation
import SnapKit
import UIKit

class SearchView: UIView {
    // MARK: Subviews
    let searchImage: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "icon_search")
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        return imageView
    }()
    let searchField: UITextField = {
        let textField = UITextField()
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.placeholder = "Let's find a book!"
        return textField
    }()
    let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubviews([searchImage, searchField, collectionView])
        searchImage.snp.makeConstraints { (make) in
            make.top.leading.equalToSuperview().offset(8)
            make.height.width.equalTo(20)
            make.centerY.equalTo(searchField)
        }
        searchField.snp.makeConstraints { (make) in
            make.top.trailing.equalToSuperview().offset(8)
            make.leading.equalTo(searchImage.snp.trailing).offset(4)
        }
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(searchField.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
