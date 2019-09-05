//
//  SearchPresenter.swift
//  LibraryBear
//
//  Created by Andrew Tran on 9/4/19.
//  Copyright © 2019 Andrew Tran. All rights reserved.
//

import Foundation

class SearchPresenter {
    private var libraryService: LibraryService?
    
    convenience init(libraryService: LibraryService) {
        self.init()
        self.libraryService = libraryService
    }
    
    func handleSearch(input: String) {
        libraryService?.fetchResultsOf(searchInput: input, onErrorMessage: { (errorMessage) in
            print(errorMessage)
        })
    }
}
