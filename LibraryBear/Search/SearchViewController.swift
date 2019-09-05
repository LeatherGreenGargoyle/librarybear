//
//  SearchViewController.swift
//  LibraryBear
//
//  Created by Andrew Tran on 9/4/19.
//  Copyright © 2019 Andrew Tran. All rights reserved.
//

import Foundation
import UIKit

class SearchViewController: BaseViewController<SearchView> {
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.set(delegate: self)
    }
}

extension SearchViewController: SearchViewDelegate {
    func onSearch(input: String) {
        print("input: \(input)")
    }
    
    
}
