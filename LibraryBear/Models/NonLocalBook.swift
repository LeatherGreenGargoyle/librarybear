//
//  Book.swift
//  LibraryBear
//
//  Created by Andrew Tran on 9/6/19.
//  Copyright © 2019 Andrew Tran. All rights reserved.
//

import Foundation

protocol Book {
    var authors: [String] { get }
    
    func getNumberOfEditions() -> String
    func getTitle() -> String
    func getFirstPublished() -> String
    func getLargeCoverURL() -> URL?
    func getMediumCoverURL() -> URL?
    func getSmallCoverURL() -> URL?
    func getAuthorSerialString() -> String
    func getAbbreviatedAuthorSerialString() -> String
    func getISBNSerialString() -> String
    func getContributorSerialString() -> String
    func getPublishersSerialString() -> String
}

struct NonLocalBook: Book {

    let title: String
    
    let authors: [String]
    
    let firstPublished: String
    
    let largeCoverURL: URL?
    
    let mediumCoverURL: URL?
    
    let smallCoverURL: URL?
    
    let isbnNumbers: [String]
    
    let contributors: [String]
    
    let numberOfEditions: String
    
    let publishers: [String]
    
    func getAuthorSerialString() -> String {
        return authors.getSerialString()
    }
    
    func getAbbreviatedAuthorSerialString() -> String {
        if let firstAuthor = authors.first, authors.count > 2 {
            return "\(firstAuthor), et al"
        } else {
            return getAuthorSerialString()
        }
    }
    
    func getISBNSerialString() -> String {
        return isbnNumbers.getSerialString()
    }
    
    func getContributorSerialString() -> String {
        return contributors.getSerialString()
    }
    
    func getPublishersSerialString() -> String {
        return publishers.getSerialString()
    }
    
    func getLargeCoverURL() -> URL? {
        return largeCoverURL
    }
    
    func getMediumCoverURL() -> URL? {
        return mediumCoverURL
    }
    
    func getSmallCoverURL() -> URL? {
        return smallCoverURL
    }
    
    func getNumberOfEditions() -> String {
        return numberOfEditions
    }
    
    func getTitle() -> String {
        return title
    }
    
    func getFirstPublished() -> String {
        return firstPublished
    }
}
