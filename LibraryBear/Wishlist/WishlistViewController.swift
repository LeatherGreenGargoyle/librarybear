//
//  WishlistViewController.swift
//  LibraryBear
//
//  Created by Andrew Tran on 9/4/19.
//  Copyright © 2019 Andrew Tran. All rights reserved.
//

import Foundation
import UIKit

protocol WishListViewDelegate: class {
    func showEmptyList()
    func show(books: [Book])
}

class WishlistViewController: BaseViewController<WishListView>, WishListViewDelegate {
    
    private var presenter: WishlistPresenter?
    private var booksToDisplay: [Book] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.collectionView.dataSource = self
        mainView.collectionView.delegate = self
        mainView.collectionView.register(BookCellView.self, forCellWithReuseIdentifier: BookCellView.identifier)
        mainView.collectionView.alwaysBounceVertical = true
        mainView.collectionView.backgroundColor = .white
        
        let newLocalDBService = LocalDBService()
        presenter = WishlistPresenter(localDBService: newLocalDBService, view: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let presenter = presenter else {
            print("WishlistPresenter nil in viewWillAppear")
            return
        }
        presenter.onViewWillAppear()
    }
    
    func showEmptyList() {
        // TODO
    }
    
    func show(books: [Book]) {
        booksToDisplay = books
        mainThread {
            self.mainView.collectionView.reloadData()
        }
    }
}

extension WishlistViewController: UICollectionViewDataSource {
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

extension WishlistViewController: UICollectionViewDelegate {
    
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
        navigationController.pushViewController(BookDetailsViewController(bookToDisplay: book, isLocal: true), animated: true)
        
    }
}

extension WishlistViewController: UICollectionViewDelegateFlowLayout {
    
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
