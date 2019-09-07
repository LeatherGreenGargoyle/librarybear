//
//  SearchViewController.swift
//  LibraryBear
//
//  Created by Andrew Tran on 9/4/19.
//  Copyright © 2019 Andrew Tran. All rights reserved.
//

import Foundation
import UIKit

class SearchViewController: BaseViewController<SearchView> {
    
    private var searchPresenter: SearchPresenter?
    private var booksToDisplay: [Book] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.set(delegate: self)
        mainView.collectionView.dataSource = self
        mainView.collectionView.delegate = self
        mainView.collectionView.register(BookCellView.self, forCellWithReuseIdentifier: BookCellView.identifier)
        mainView.collectionView.alwaysBounceVertical = true
        mainView.collectionView.backgroundColor = .white
        
        let newLibaryService = LibraryService()
        searchPresenter = SearchPresenter(
            libraryService: newLibaryService,
            view: self
        )
    }
    
    func onQuery(error: String) {
        // TODO: display user error message
        print("Error received by SearchVC: \(error)")
        booksToDisplay.removeAll(keepingCapacity: false)
        mainThread {
            self.mainView.collectionView.reloadData()
        }
    }
    
    func onQuery(results: [Book]) {
        booksToDisplay = results
        mainThread {
            self.mainView.collectionView.reloadData()
        }
    }
    
    func onQuery(moreResults: [Book]) {
        booksToDisplay.append(contentsOf: moreResults)
        print("displaying more results...")
        mainThread {
            self.mainView.collectionView.reloadData()
        }
    }
    
    func showEmptyList() {
        booksToDisplay.removeAll(keepingCapacity: false)
        mainThread {
            self.mainView.collectionView.reloadData()
        }
    }
}

extension SearchViewController: SearchViewDelegate {
    func onSearch(input: String) {
        searchPresenter?.handleSearch(input: input)
    }
}

extension SearchViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return booksToDisplay.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookCellView.identifier,
                                                            for: indexPath) as? BookCellView else {
            print("Unable to dequeue BookCellView")
            return UICollectionViewCell()
        }
        
        defer {
            searchPresenter?.handleWillDisplay(finalBook: indexPath.row >= booksToDisplay.count - 20)
        }
        
        let book = booksToDisplay[indexPath.item]
        cell.set(
            title: book.getTitle(),
            author: book.getAbbreviatedAuthorSerialString(),
            publishDate: book.getFirstPublished()
        )
        if let url = book.getMediumCoverURL() {
            cell.set(coverURL: url)
        }
        return cell
    }
}

extension SearchViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.row <= booksToDisplay.count else {
            print("didSelectItem at a row greater than data count")
            return
        }
        guard let navigationController = navigationController else {
            print("Missing SearchNavigationController")
            return
        }
        let book = booksToDisplay[indexPath.row]
        navigationController.pushViewController(BookDetailsViewController(bookToDisplay: book), animated: true)

    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width * 0.4, height: UIScreen.main.bounds.height * 0.3)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
