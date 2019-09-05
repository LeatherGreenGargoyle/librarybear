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

protocol SearchViewDelegate: class {
    func onSearch(input: String)
}

class SearchView: UIView {
    // MARK: Subviews
    private let header: UILabel = {
        let label = UILabel()
        label.text = "I am the SearchView"
        label.font = .regular14
        return label
    }()
    private let searchField: UITextField = {
        let textField = UITextField()
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.placeholder = "Let's find a book!"
        return textField
    }()
    
    // MARK: Members
    private var delegate: SearchViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubviews([header, searchField])
        searchField.addTarget(self, action: #selector(onSearchInput), for: .editingChanged)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        header.snp.updateConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
        }
        searchField.snp.updateConstraints { (make) in
            make.top.equalTo(header.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    func set(delegate: SearchViewDelegate) {
        self.delegate = delegate
    }
    
    @objc func onSearchInput(_ textField: UITextField) {
        guard let delegate = delegate else {
            print("Missing delegate")
            return
        }
        delegate.onSearch(input: textField.text ?? "")
    }
}
