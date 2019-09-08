//
//  WishlistPresenter.swift
//  LibraryBear
//
//  Created by Andrew Tran on 9/7/19.
//  Copyright © 2019 Andrew Tran. All rights reserved.
//

import Foundation

/*
    So what should this look like?
        - onAttachView, we should query realm
        - we get the results, hand them to VC
        - VC reloads the table
 */

class WishlistPresenter {
    
    private var localDBService: LocalDBService?
    private weak var wishlistView: WishListViewDelegate?
    private var booksToDisplay: [Book] = []
    
    convenience init(localDBService: LocalDBService, view: WishListViewDelegate) {
        self.init()
        self.localDBService = localDBService
        self.wishlistView = view
        
        onAttachView()
    }
    
    func onViewWillAppear() {
        guard let view = wishlistView else {
            print("WishListViewDelegate nil onAttachView")
            return
        }
        
        if let cachedBooks = getAllCachedBooks() {
            booksToDisplay = cachedBooks
        }
        
        view.refreshTable()
    }
    
    func getBookCount() -> Int {
        return booksToDisplay.count
    }
    
    func getBookAt(index: Int) -> Book? {
        guard index < booksToDisplay.count else {
            return nil
        }
        
        return booksToDisplay[index]
    }
    
    func handleBookClickAt(row: Int) {
        guard let view = wishlistView else {
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
    
    private func onAttachView() {
        guard let view = wishlistView else {
            print("WishListViewDelegate nil onAttachView")
            return
        }
        view.refreshTable()
    }
    
    private func getAllCachedBooks() -> [Book]? {
        return localDBService?.getCachedBooks()
    }
}
