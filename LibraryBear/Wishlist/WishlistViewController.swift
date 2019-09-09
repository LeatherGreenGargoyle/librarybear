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
    func refreshTable()
    func showDetailsViewFor(book: Book)
}

/// ViewController responsible for CollectionView management and BookDetails presentation.
class WishlistViewController: BaseViewController<WishListView>, WishListViewDelegate {
    
    private var presenter: WishlistPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.collectionView.dataSource = self
        mainView.collectionView.delegate = self
        mainView.collectionView.register(BookCellView.self, forCellWithReuseIdentifier: BookCellView.identifier)
        mainView.collectionView.alwaysBounceVertical = true
        mainView.collectionView.backgroundColor = .white
        mainView.collectionView.register(EmptyTableView.self,
                                         forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                         withReuseIdentifier: EmptyTableView.identifier)
        
        navigationItem.title = "Your Wishlist"
        navigationController?.navigationBar.titleTextAttributes =
            [.foregroundColor : UIColor.lbBrown]
        navigationController?.navigationBar.tintColor = .lbBrown
        
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
    
    func refreshTable() {
        mainThread {
            self.mainView.collectionView.reloadData()
        }
    }
    
    /**
     Presents a view containing further details of a selected book
     
     - Parameters:
        - book: The selected book
     */
    func showDetailsViewFor(book: Book) {
        guard let navigationController = navigationController else {
            print("Missing SearchNavigationController")
            return
        }
        
        navigationController.pushViewController(
            BookDetailsViewController(bookToDisplay: book),
            animated: true
        )
    }
}

extension WishlistViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        guard let presenter = presenter else {
            print("WishlistPresenter nil")
            return 0
        }
        return presenter.getBookCount()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let presenter = presenter else {
            print("WishlistPresenter nil")
            return UICollectionViewCell()
        }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookCellView.identifier,
                                                            for: indexPath) as? BookCellView else {
                                                                print("Unable to dequeue BookCellView")
                                                                return UICollectionViewCell()
        }
        
        guard let book = presenter.getBookAt(index: indexPath.item) else {
            print("Attempted to access cached book at invalid index")
            return UICollectionViewCell()
        }
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
        guard let presenter = presenter else {
            print("WishlistPresenter nil")
            return
        }
        presenter.handleBookClickAt(row: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: EmptyTableView.identifier, for: indexPath) as? EmptyTableView else {
                return UICollectionReusableView()
            }
            
            headerView.setMainText("Try searching for books and saving them!")
            headerView.setSubText("Your saved books will appear here.")
            return headerView
        default:
            return UICollectionReusableView()
        }
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
        return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard let presenter = presenter else {
            print("SearchPresenter nil in ReferenceSizeForHeaderInSection")
            return CGSize.zero
        }
        
        if presenter.getBookCount() > 0 {
            return CGSize.zero
        } else {
            return CGSize(width: collectionView.frame.width, height: 180.0)
        }
    }
}
