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
    
    convenience init(localDBService: LocalDBService, view: WishListViewDelegate) {
        self.init()
        self.localDBService = localDBService
        self.wishlistView = view
        
        onAttachView()
    }
    
    private func onAttachView() {
        guard let view = wishlistView else {
            print("WishListViewDelegate nil onAttachView")
            return
        }
        guard let books = getAllCachedBooks() else {
            view.showEmptyList()
            return
        }
        
        view.show(books: books)
    }
    
    private func getAllCachedBooks() -> [Book]? {
        return localDBService?.getCachedBooks()
    }
}
