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
    private var isLocal: Bool = false
    
    convenience init(localDBService: LocalDBService, book: Book, delegate: BookDetailsViewDelegate, isLocal: Bool) {
        self.init()
        self.localDBService = localDBService
        self.viewDelegate = delegate
        self.selectedBook = book
        self.isLocal = isLocal
        
        onAttachView()
    }
    
    func onAttachView() {
        guard let selectedBook = self.selectedBook, let viewDelegate = self.viewDelegate else {
            print("BookDetailsPresenter error, selectedBook present? \(self.selectedBook != nil), viewDelegate present? \(self.viewDelegate != nil)")
            return
        }
        
        viewDelegate.set(
            title: selectedBook.getTitle(),
            authors: selectedBook.getAuthorSerialString(),
            isbnList: selectedBook.getISBNSerialString(),
            publishersList: selectedBook.getPublishersSerialString(),
            publishingDate: selectedBook.getFirstPublished(),
            contributorsList: selectedBook.getContributorSerialString(),
            numberOfEditions: selectedBook.getNumberOfEditions())
        
        if let url = selectedBook.getLargeCoverURL() {
            viewDelegate.setCover(url: url)
        }
        let buttonTitle = isLocal ? "REMOVE FROM LIBRARY" : "SAVE"
        viewDelegate.setButton(title: buttonTitle)
    }
    
    func handleButtonClick() {
        if isLocal, let book = selectedBook as? LocalBook {
            removeFromCache(book: book)
        } else if !isLocal, let book = selectedBook as? NonLocalBook {
            cache(book: book)
        } else {
            let errorMessage = isLocal ?
                "BookDetails click, unable to cast local book" :
                "BookDetails click, unable to cast nonLocalBook"
            print(errorMessage)
        }
    }
    
    private func cache(book: NonLocalBook) {
        guard let localDBService = localDBService else {
            print("LocalDBService nil")
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
                    delegate.showActionErrorAlert(
                        message: "Looks like you've already saved this book!",
                        title: "Hmm..."
                    )
                case .failedToSave:
                    delegate.showActionErrorAlert(
                        message: "There was an issue saving this book, please try again later.",
                        title: "Hmm..."
                    )
                default:
                    return
                }
                return
            }
            
            guard success else {
                return
            }
            
            delegate.showActionSuccessAlert(message: "Book saved!", title: "Alright!") {
                delegate.dismissBookDetailsView()
            }
        }
    }
    
    private func removeFromCache(book: LocalBook) {
        guard let localDBService = localDBService else {
            print("LocalDBService nil")
            return
        }
        
        localDBService.removeCached(book: book) { (success, error) in
            guard let delegate = viewDelegate else {
                print("Missing BookDetailsViewDelegate")
                return
            }
            
            if let error = error {
                switch error {
                case .failedToDelete:
                    delegate.showActionErrorAlert(
                        message: "There was an issue removing this book, please try again later.",
                        title: "Hmm..."
                    )
                default:
                    return
                }
                return
            }
            
            delegate.showActionSuccessAlert(message: "Book removed!", title: "Alright!") {
                delegate.dismissBookDetailsView()
            }
        }
    }
    
}
