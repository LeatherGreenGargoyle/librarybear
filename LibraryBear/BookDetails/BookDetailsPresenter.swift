//
//  BookDetailsPresenter.swift
//  LibraryBear
//
//  Created by Andrew Tran on 9/5/19.
//  Copyright © 2019 Andrew Tran. All rights reserved.
//

import Foundation

class BookDetailsPresenter {
    private var localDBService: LocalDBService?
    private weak var bookDetailsView: BookDetailsViewController?
    convenience init(localDBService: LocalDBService, bookDetailsView: BookDetailsViewController) {
        self.init()
        self.localDBService = localDBService
        self.bookDetailsView = bookDetailsView
    }
}

extension BookDetailsPresenter: BookDetailsViewDelegate {
    func onActionButtonPress() {
        // no-op
    }
}
