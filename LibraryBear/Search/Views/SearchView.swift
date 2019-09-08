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
import VegaScrollFlowLayout

class SearchView: UIView {
    // MARK: Subviews
    private let header: UILabel = {
        let label = UILabel()
        label.text = "I am the SearchView"
        label.font = .regular14
        return label
    }()
    let searchField: UITextField = {
        let textField = UITextField()
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.placeholder = "Let's find a book!"
        return textField
    }()
    let collectionView: UICollectionView = {
        let layout = VegaScrollFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubviews([header, searchField, collectionView])
        
        header.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
        }
        searchField.snp.makeConstraints { (make) in
            make.top.equalTo(header.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(searchField.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
