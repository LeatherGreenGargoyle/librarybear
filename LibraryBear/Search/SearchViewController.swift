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
    var searchPresenter: SearchPresenter?
    var libraryService: LibraryService?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.set(delegate: self)
        
        let newLibaryService = LibraryService()
        searchPresenter = SearchPresenter(libraryService: newLibaryService)
        libraryService = newLibaryService
    }
}

extension SearchViewController: SearchViewDelegate {
    func onSearch(input: String) {
        searchPresenter?.handleSearch(input: input)
    }
}
