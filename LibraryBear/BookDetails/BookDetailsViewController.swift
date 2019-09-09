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
    func set(title: String, authors: String, isbnList: String, publishersList: String, publishingDate: String,
             contributorsList: String, numberOfEditions: String)
    func setButton(title: String)
    func setCover(url: URL)
    func showActionErrorAlert(message: String, title: String)
    func showActionSuccessAlert(message: String, title: String, then callback: @escaping Callback)
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
        
        mainView.actionButton.addTarget(self, action: #selector(onActionButtonPress), for: .touchUpInside)
    }
    
    func set(title: String, authors: String, isbnList: String, publishersList: String, publishingDate: String,
             contributorsList: String, numberOfEditions: String) {
        mainView.set(title: title)
        mainView.set(authors: authors)
        mainView.set(isbnList: isbnList)
        mainView.set(publishersList: publishersList)
        mainView.set(publishingDate: publishingDate)
        mainView.set(contributorsList: contributorsList)
        mainView.set(numberOfEditions: numberOfEditions)
    }
    
    func setButton(title: String) {
        mainView.actionButton.setTitle(title, for: .normal)
    }
    
    func setCover(url: URL) {
        mainView.setCoverImage(url: url)
    }
    
    @objc private func onActionButtonPress() {
        guard let bookDetailsPresenter = self.bookDetailsPresenter else {
            print("BookDetailsPresenter nil")
            return
        }
        bookDetailsPresenter.handleButtonClick()
    }
    
    func dismissBookDetailsView() {
        guard let navigationController = navigationController else {
            print("NavigationController nil in BookDetails")
            return
        }
        navigationController.popViewController(animated: true)
    }
    
    func showActionErrorAlert(message: String, title: String) {
        showAlert(title: title, message: message)
    }
    
    func showActionSuccessAlert(message: String, title: String, then callback: @escaping Callback) {
        showAlert(title: title, message: message) { _ in
            callback()
        }
    }
}
