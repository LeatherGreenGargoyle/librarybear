//
//  EmptyTableCellView.swift
//  LibraryBear
//
//  Created by Andrew Tran on 9/8/19.
//  Copyright © 2019 Andrew Tran. All rights reserved.
//

import Foundation
import SnapKit
import UIKit

class EmptyTableView: UICollectionReusableView {
    
    static var identifier: String = "EmptyTableCellView"
    
    private let mainText: UILabel = {
        let label = UILabel()
        label.font = .bold18
        label.textAlignment = .center
        label.textColor = .lbBrown
        return label
    }()
    private let subText: UILabel = {
        let label = UILabel()
        label.font = .regular14
        label.textAlignment = .center
        label.textColor = .lbBrown
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews([mainText, subText])
        mainText.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        subText.snp.makeConstraints { (make) in
            make.top.equalTo(mainText.snp.bottom)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
    }
    
    func setMainText(_ text: String) {
        mainText.text = text
    }
    
    func setSubText(_ text: String) {
        subText.text = text
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
