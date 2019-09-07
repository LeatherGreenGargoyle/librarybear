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
    private weak var view: SearchViewDelegate?
    private var isCurrentlyFetchingMore = false
    private var booksToDisplay: [Book] = []
    
    convenience init(libraryService: LibraryService, view: SearchViewDelegate) {
        self.init()
        self.libraryService = libraryService
        self.view = view
    }
    
    func handleBookClickAt(row: Int) {
        guard let view = view else {
            print("ViewDelegate nil in handleBookClick")
            return
        }
        guard row <= booksToDisplay.count else {
            print("didSelectItem at a row greater than data count")
            return
        }
        let book = booksToDisplay[row]
        view.showDetailsViewFor(book: book)
    }
    
    func handleSearch(input: String) {
        guard let view = view else {
            print("ViewDelegate nil in handleSearchError")
            return
        }
        guard input.count > 0 else {
            view.showEmptyList()
            return
        }
        currentSearchBufferTimer?.invalidate()
        
        currentSearchBufferTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { _ in
                self.libraryService?.fetchResultsOf(
                    searchInput: input,
                    onResult: self.handleSearchQuery,
                    onErrorMessage: self.handleSearchError
            )
        })
    }
    
    func handleWillDisplay(row: Int) {
        let shouldFetchMore = row >= booksToDisplay.count - 20
        guard shouldFetchMore, !isCurrentlyFetchingMore else {
            return
        }
        
        isCurrentlyFetchingMore = true
        
        libraryService?.fetchMoreResults(onResult: handleMore, onErrorMessage: handleSearchError)
    }
    
    func getFetchedBook(at index: Int) -> Book? {
        guard index <= booksToDisplay.count else {
            return nil
        }
        
        return booksToDisplay[index]
    }
    
    func getBookCount() -> Int {
        return booksToDisplay.count
    }
    
    private func handleSearchError(error: String) {
        guard let view = view else {
            print("ViewDelegate nil in handleSearchError")
            return
        }
        booksToDisplay.removeAll()
        view.refreshTable()
        view.showSearchErrorAlert(message: "Hmm...", title: "We couldn't complete your search right now, please try again later.")
    }
    
    private func handleSearchQuery(results: [Book]) {
        guard let view = view else {
            print("ViewDelegate nil in handleSearchError")
            return
        }
        booksToDisplay = results
        view.refreshTable()
    }
    
    private func handleMore(results: [Book]) {
        guard let view = view else {
            print("ViewDelegate nil in handleSearchError")
            return
        }
        booksToDisplay.append(contentsOf: results)
        isCurrentlyFetchingMore = false
        view.refreshTable()
    }
}
