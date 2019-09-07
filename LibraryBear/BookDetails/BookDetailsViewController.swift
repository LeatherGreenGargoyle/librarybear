//
//  BookDetailsViewController.swift
//  LibraryBear
//
//  Created by Andrew Tran on 9/5/19.
//  Copyright © 2019 Andrew Tran. All rights reserved.
//

import Foundation

protocol BookDetailsViewDelegate: class {
    func dismissBookDetailsView()
    func showSaveErrorAlert(message: String, title: String)
    func showSaveSuccessAlert(message: String, title: String, then callback: @escaping Callback)
}

class BookDetailsViewController: BaseViewController<BookDetailsView>, BookDetailsViewDelegate {
    
    private var bookDetailsPresenter: BookDetailsPresenter?
    
    convenience init(bookToDisplay: Book) {
        self.init()
        
        let newLocalDBService = LocalDBService()
        
        let newBookDetailsPresenter = BookDetailsPresenter(
            localDBService: newLocalDBService,
            book: bookToDisplay,
            delegate: self
        )
        bookDetailsPresenter = newBookDetailsPresenter
        
        if let url = bookToDisplay.getLargeCoverURL() {
            mainView.setCoverImage(url: url)
        }
        mainView.set(title: bookToDisplay.getTitle())
        mainView.set(authors: bookToDisplay.getAuthorSerialString())
        mainView.set(isbnList: bookToDisplay.getISBNSerialString())
        mainView.set(publishersList: bookToDisplay.getPublishersSerialString())
        mainView.set(publishingDate: bookToDisplay.getFirstPublished())
        mainView.set(contributorsList: bookToDisplay.getContributorSerialString())
        mainView.set(numberOfEditions: bookToDisplay.getNumberOfEditions())
        mainView.saveButton.setTitle("SAVE", for: .normal)
        mainView.saveButton.addTarget(self, action: #selector(onSavePress), for: .touchUpInside)
    }
    
    @objc private func onSavePress() {
        guard let bookDetailsPresenter = self.bookDetailsPresenter else {
            print("BookDetailsPresenter nil")
            return
        }
        bookDetailsPresenter.handleSaveClick()
    }
    
    func dismissBookDetailsView() {
        guard let navigationController = navigationController else {
            print("NavigationController nil in BookDetails")
            return
        }
        navigationController.popViewController(animated: true)
    }
    
    func showSaveErrorAlert(message: String, title: String) {
        showAlert(title: title, message: message)
    }
    
    func showSaveSuccessAlert(message: String, title: String, then callback: @escaping Callback) {
        showAlert(title: title, message: message) { _ in
            callback()
        }
    }
}
