//
//  SearchViewController.swift
//  LibraryBear
//
//  Created by Andrew Tran on 9/4/19.
//  Copyright © 2019 Andrew Tran. All rights reserved.
//

import Foundation
import UIKit

protocol SearchViewDelegate: class {
    func refreshTable()
    func showEmptyList()
    func showSearchErrorAlert(message: String, title: String)
    func showDetailsViewFor(book: Book)
}

class SearchViewController: BaseViewController<SearchView>, SearchViewDelegate {

    private var searchPresenter: SearchPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.collectionView.dataSource = self
        mainView.collectionView.delegate = self
        mainView.collectionView.register(BookCellView.self, forCellWithReuseIdentifier: BookCellView.identifier)
        mainView.collectionView.alwaysBounceVertical = true
        mainView.collectionView.backgroundColor = .white
        mainView.searchField.addTarget(
            self, action: #selector(searchInputted), for: .editingChanged
        )
        navigationItem.title = "Library Bear"
        navigationController?.navigationBar.titleTextAttributes =
            [.foregroundColor : UIColor.brown]
        navigationController?.navigationBar.tintColor = .brown
        
        let newLibaryService = LibraryService()
        searchPresenter = SearchPresenter(
            libraryService: newLibaryService,
            view: self
        )
    }
    
    func showSearchErrorAlert(message: String, title: String) {
        showAlert(title: title, message: message)
    }
    
    func showEmptyList() {
        // TODO
    }
    
    func refreshTable() {
        mainThread {
            self.mainView.collectionView.reloadData()
        }
    }
    
    func showDetailsViewFor(book: Book) {
        guard let navigationController = navigationController else {
            print("Missing SearchNavigationController")
            return
        }
        
        navigationController.pushViewController(
            BookDetailsViewController(bookToDisplay: book, isLocal: false),
            animated: true
        )
    }
    
    @objc private func searchInputted(_ textField: UITextField) {
        guard let searchPresenter = searchPresenter else {
            print("Missing SearchPresenter on searchInputted")
            return
        }
        
        searchPresenter.handleSearch(input: textField.text ?? "")
    }
}

extension SearchViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        guard let searchPresenter = searchPresenter else {
            print("Missing SearchPresenter on searchInputted")
            return 0
        }
        
        return searchPresenter.getBookCount()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let searchPresenter = searchPresenter else {
            print("Missing SearchPresenter on cellForItemAt")
            return UICollectionViewCell()
        }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookCellView.identifier,
                                                            for: indexPath) as? BookCellView else {
            print("Unable to dequeue BookCellView")
            return UICollectionViewCell()
        }
        guard let book = searchPresenter.getFetchedBook(at: indexPath.row) else {
            return UICollectionViewCell()
        }
        
        defer {
            searchPresenter.handleWillDisplay(row: indexPath.row)
        }
        
        cell.set(
            title: book.getTitle(),
            author: book.getAbbreviatedAuthorSerialString(),
            publishDate: book.getFirstPublished()
        )
        if let url = book.getMediumCoverURL() {
            cell.set(coverURL: url)
        }
        
        cell.setRoundCorners([.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 12)
        
        return cell
    }
}

extension SearchViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let searchPresenter = searchPresenter else {
            print("Missing SearchPresenter on didSelectItemAt")
            return
        }
        searchPresenter.handleBookClickAt(row: indexPath.row)
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width * 0.45, height: UIScreen.main.bounds.height * 0.35)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}
