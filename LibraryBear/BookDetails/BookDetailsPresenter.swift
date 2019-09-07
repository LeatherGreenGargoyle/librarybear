//
//  BookDetailsPresenter.swift
//  LibraryBear
//
//  Created by Andrew Tran on 9/5/19.
//  Copyright © 2019 Andrew Tran. All rights reserved.
//

import Foundation

class BookDetailsPresenter {
    private var localDBService: LocalDBService?
    private weak var viewDelegate: BookDetailsViewDelegate?
    private var selectedBook: Book?
    
    convenience init(localDBService: LocalDBService, book: Book, delegate: BookDetailsViewDelegate) {
        self.init()
        self.localDBService = localDBService
        self.viewDelegate = delegate
        self.selectedBook = book
    }
    
    func handleSaveClick() {
        guard let localDBService = localDBService else {
            print("LocalDBService nil")
            return
        }
        guard let book = selectedBook else {
            print("Book nil")
            return
        }
        
        localDBService.cache(book: book) { success, dbError in
            guard let delegate = viewDelegate else {
                print("Missing BookDetailsViewDelegate")
                return
            }
            
            if let error = dbError {
                switch error {
                case .alreadySaved:
                    delegate.showSaveErrorAlert(
                        message: "Looks like you've already saved this book!",
                        title: "Hmm..."
                    )
                case .failedToSave:
                    delegate.showSaveErrorAlert(
                        message: "There was an issue saving this book, please try again later.",
                        title: "Hmm..."
                    )
                }
                return
            }
            
            guard success else {
                return
            }
            
            delegate.showSaveSuccessAlert(message: "Book saved!", title: "Alright!") {
                delegate.dismissBookDetailsView()
            }
        }
    }
}
