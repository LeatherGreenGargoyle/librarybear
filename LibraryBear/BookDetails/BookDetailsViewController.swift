//
//  BookDetailsViewController.swift
//  LibraryBear
//
//  Created by Andrew Tran on 9/5/19.
//  Copyright © 2019 Andrew Tran. All rights reserved.
//

import Foundation

class BookDetailsViewController: BaseViewController<BookDetailsView> {
    private var bookDetailsPresenter: BookDetailsPresenter?
    
    convenience init(bookToDisplay: Book) {
        self.init()
        
        let newLocalDBService = LocalDBService()
        
        let newBookDetailsPresenter = BookDetailsPresenter(
            localDBService: newLocalDBService,
            bookDetailsView: self
        )
        bookDetailsPresenter = newBookDetailsPresenter
        
        if let url = bookToDisplay.largeCoverURL {
            mainView.setCoverImage(url: url)
        }
        mainView.set(delegate: newBookDetailsPresenter)
        mainView.set(title: bookToDisplay.title)
        mainView.set(authors: bookToDisplay.getAuthorSerialString())
        mainView.set(isbnList: bookToDisplay.getISBNSerialString())
        mainView.set(publishersList: bookToDisplay.getPublishersSerialString())
        mainView.set(publishingDate: bookToDisplay.firstPublished)
        mainView.set(contributorsList: bookToDisplay.getContributerSerialString())
        mainView.set(numberOfEditions: bookToDisplay.numberOfEditions)
        mainView.setButton(title: "SAVE", handler: {})
    }
}
