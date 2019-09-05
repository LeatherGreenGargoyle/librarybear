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
    private let header: UILabel = {
        let label = UILabel()
        label.text = "I am the SearchView"
        label.font = .regular14
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(header)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        header.snp.updateConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
        }
    }
}
