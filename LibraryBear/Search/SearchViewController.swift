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
    private var searchPresenter: SearchPresenter?
    private var libraryService: LibraryService?
    private var booksToDisplay: [Book]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.set(delegate: self)
        
        let newLibaryService = LibraryService()
        searchPresenter = SearchPresenter(libraryService: newLibaryService, view: self)
        libraryService = newLibaryService
    }
    
    func onQuery(error: String) {
        // TODO: display user error message
        print("Error received by SearchVC: \(error)")
    }
    
    func onQuery(results: [Book]) {
        booksToDisplay = results
    }
}

extension SearchViewController: SearchViewDelegate {
    func onSearch(input: String) {
        searchPresenter?.handleSearch(input: input)
    }
}
