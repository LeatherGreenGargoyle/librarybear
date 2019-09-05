//
//  SearchPresenter.swift
//  LibraryBear
//
//  Created by Andrew Tran on 9/4/19.
//  Copyright © 2019 Andrew Tran. All rights reserved.
//

import Foundation

class SearchPresenter {
    private var libraryService: LibraryService?
    private weak var searchView: SearchViewController?
    
    convenience init(libraryService: LibraryService, view: SearchViewController) {
        self.init()
        self.libraryService = libraryService
        self.searchView = view
    }
    
    func handleSearch(input: String) {
        libraryService?.fetchResultsOf(searchInput: input, onResult: handleSearchQuery, onErrorMessage: handleSearchQuery)
    }
    
    private func handleSearchQuery(error: String) {
        searchView?.onQuery(error: error)
    }
    
    private func handleSearchQuery(results: [Book]) {
        searchView?.onQuery(results: results)
    }
}
