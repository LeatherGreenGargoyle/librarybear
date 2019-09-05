//
//  SearchPresenter.swift
//  LibraryBear
//
//  Created by Andrew Tran on 9/4/19.
//  Copyright © 2019 Andrew Tran. All rights reserved.
//

import Foundation

class SearchPresenter {
    
    private var currentSearchBufferTimer: Timer?
    private var libraryService: LibraryService?
    private weak var searchView: SearchViewController?
    
    convenience init(libraryService: LibraryService, view: SearchViewController) {
        self.init()
        self.libraryService = libraryService
        self.searchView = view
    }
    
    func handleSearch(input: String) {
        guard input.count > 0 else {
            searchView?.showEmptyList()
            return
        }
        currentSearchBufferTimer?.invalidate()
        
        currentSearchBufferTimer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false, block: { _ in
                self.libraryService?.fetchResultsOf(
                    searchInput: input,
                    onResult: self.handleSearchQuery,
                    onErrorMessage: self.handleSearchError
            )
        })
    }
    
    func handleWillDisplay(finalBook isFinalBook: Bool) {
        guard isFinalBook else {
            return
        }
        
        libraryService?.fetchMoreResults(onResult: handleMore, onErrorMessage: handleSearchError)
    }
    
    private func handleSearchError(error: String) {
        searchView?.onQuery(error: error)
    }
    
    private func handleSearchQuery(results: [Book]) {
        searchView?.onQuery(results: results)
    }
    
    private func handleMore(results: [Book]) {
        searchView?.onQuery(moreResults: results)
    }
}
