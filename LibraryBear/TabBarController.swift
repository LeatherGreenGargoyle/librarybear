//
//  TabBarController.swift
//  LibraryBear
//
//  Created by Andrew Tran on 9/4/19.
//  Copyright © 2019 Andrew Tran. All rights reserved.
//

import Foundation
import SnapKit
import UIKit

enum TabIndex: Int {
    case search = 0, wishlist
}

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    private let searchViewController = SearchViewController()
    private let wishListViewController = WishlistViewController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let searchNavigationController = UINavigationController()
        searchNavigationController.addChild(searchViewController)
        searchNavigationController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: TabIndex.search.rawValue)
        let wishListNavigationController = UINavigationController()
        wishListNavigationController.addChild(wishListViewController)
        wishListNavigationController.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: TabIndex.search.rawValue)
        
        viewControllers = [searchNavigationController, wishListNavigationController]
    }
}
