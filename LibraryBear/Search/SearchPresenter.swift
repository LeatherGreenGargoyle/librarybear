//
//  SearchPresenter.swift
//  LibraryBear
//
//  Created by Andrew Tran on 9/4/19.
//  Copyright © 2019 Andrew Tran. All rights reserved.
//

import Foundation

/// Presenter class handling user search inputs, book selection, querying for paginated results, and model
/// access.
class SearchPresenter {
    
    private var currentSearchBufferTimer: Timer?
    private var libraryService: LibraryService?
    private var localDBService: LocalDBService?
    private weak var view: SearchViewDelegate?
    private var isCurrentlyFetchingMore = false
    private var booksToDisplay: [Book] = []
    private var lastSearchInput = ""
    private var wereLastResultsEmpty = false
    
    convenience init(libraryService: LibraryService, view: SearchViewDelegate) {
        self.init()
        self.libraryService = libraryService
        self.view = view
    }
    
    /**
     A handler for SearchView collection result clicks, which will display the BookDetailsView.
     
     - Parameters:
        - row: The position of the selected book within the CollectionView
     */
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
    
    /**
     A handler for user search inputs, which will trigger API calls with a staggered time buffer to
     prevent extraneous calls.
     
     - Parameters:
        - input: The provided search string.
     */
    func handleSearch(input: String) {
        lastSearchInput = input
        guard input.count > 0 else {
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
    
    /**
     A handler which will trigger when the user has neared the end of the currently-displayed book results,
     and which will then trigger a paginated query to the library API.
     
     - Parameters:
        - row: The position of the just-displayed Book item, within the CollectionView
     */
    func handleWillDisplay(row: Int) {
        let shouldFetchMore = row >= (max(booksToDisplay.count - 20, 0))
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
    
    func getEmptyCollectionMessage() -> String {
        return wereLastResultsEmpty ? "We couldn't find anything for your last search" : "Your results will appear here."
    }
    
    /**
     An error handler which will remove all queried books and display an empty view and error message.
     */
    private func handleSearchError(error: String) {
        guard let view = view else {
            print("ViewDelegate nil in handleSearchError")
            return
        }
        booksToDisplay.removeAll()
        view.refreshTable()
        view.showSearchErrorAlert(message: "Hmm...", title: "We couldn't complete your search right now, please try again later.")
    }
    
    /**
     Handler for Book query results, which will save the books as a local property, or remove them in the
     event of a query with no results. Then triggers a collectionView refresh and scrolls the view to the
     top.
     
     - Parameters:
        - results: An array containing the book results.
     */
    private func handleSearchQuery(results: [Book]) {
        guard let view = view else {
            print("ViewDelegate nil in handleSearchError")
            return
        }
        if lastSearchInput.count > 0 {
            booksToDisplay = results
        } else {
            booksToDisplay.removeAll()
        }
        
        wereLastResultsEmpty = results.isEmpty
        
        view.refreshTable()
        view.scrollToTop()
    }
    
    /**
     Handler for a paginated book query, which appends the results to the locally-stored books property,
     and refresh the view.
     
     - Parameters:
        - formattedSearchString: An array containing the book results.
     */
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
