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

/// Class containing NavigationControllers for all displayed main pages.
class TabBarController: UITabBarController, UITabBarControllerDelegate {
    private let searchViewController = SearchViewController()
    private let wishListViewController = WishlistViewController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.tintColor = .lbBrown
        
        let searchNavigationController = UINavigationController()
        searchNavigationController.addChild(searchViewController)
        let searchItem = UITabBarItem(title: nil, image: UIImage(named: "icon_search"), tag: 0)
        searchItem.imageInsets = UIEdgeInsets(top: 7, left: 0, bottom: -7, right: 0)
        searchNavigationController.tabBarItem = searchItem

        let wishListNavigationController = UINavigationController()
        wishListNavigationController.addChild(wishListViewController)
        let wishListItem = UITabBarItem(title: nil, image: UIImage(named: "icon_book"), tag: 0)
        wishListItem.imageInsets = UIEdgeInsets(top: 7, left: 0, bottom: -7, right: 0)
        wishListNavigationController.tabBarItem = wishListItem
        
        searchNavigationController.navigationBar.topItem?.backBarButtonItem =
            UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        viewControllers = [searchNavigationController, wishListNavigationController]
    }
}
