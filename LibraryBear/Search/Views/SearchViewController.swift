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
    private let REUSE_ID_BOOK_CELL = "bookTableViewCell"
    
    private var searchPresenter: SearchPresenter?
    private var booksToDisplay: [Book] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.set(delegate: self)
        mainView.tableView.register(BookTableViewCell.self, forCellReuseIdentifier: REUSE_ID_BOOK_CELL)
        mainView.tableView.rowHeight = 100
        mainView.tableView.allowsSelection = true
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        
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
            self.mainView.tableView.reloadData()
        }
    }
    
    func onQuery(results: [Book]) {
        booksToDisplay = results
        mainThread {
            self.mainView.tableView.reloadData()
        }
    }
    
    func onQuery(moreResults: [Book]) {
        booksToDisplay.append(contentsOf: moreResults)
        print("displaying more results...")
        mainThread {
            self.mainView.tableView.reloadData()
        }
    }
    
    func showEmptyList() {
        booksToDisplay.removeAll(keepingCapacity: false)
        mainThread {
            self.mainView.tableView.reloadData()
        }
    }
}

extension SearchViewController: SearchViewDelegate {
    func onSearch(input: String) {
        searchPresenter?.handleSearch(input: input)
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        defer {
            searchPresenter?.handleWillDisplay(finalBook: indexPath.row == booksToDisplay.count - 1)
        }
        
        guard indexPath.row <= booksToDisplay.count else {
            mainThread {
                self.mainView.tableView.reloadData()
            }
            return UITableViewCell()
        }
        guard let cell = mainView.tableView
            .dequeueReusableCell(withIdentifier: REUSE_ID_BOOK_CELL) as? BookTableViewCell else {
                return UITableViewCell()
        }
        
        let book = booksToDisplay[indexPath.row]
        cell.set(title: book.title)
        cell.set(authors: book.getAuthorSerialString())
        if let url = book.mediumCoverURL {
            cell.set(coverURL: url)
        }
        cell.set(publishDate: book.firstPublished)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let book = booksToDisplay[indexPath.row]
        guard let navigationController = navigationController else {
            print("Missing SearchNavigationController")
            return
        }
        navigationController.pushViewController(BookDetailsViewController(bookToDisplay: book), animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return booksToDisplay.count
    }
}
