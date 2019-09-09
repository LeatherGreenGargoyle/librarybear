//
//  Book.swift
//  LibraryBear
//
//  Created by Andrew Tran on 9/6/19.
//  Copyright © 2019 Andrew Tran. All rights reserved.
//

import Foundation

protocol Book {
    func getId() -> String
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
    
    let largeCoverURL: String?
    
    let mediumCoverURL: String?
    
    let smallCoverURL: String?
    
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
        guard let largeCoverURL = self.largeCoverURL else {
            return nil
        }
        return URL(string: largeCoverURL)
    }
    
    func getMediumCoverURL() -> URL? {
        guard let mediumCoverURL = self.mediumCoverURL else {
            return nil
        }
        return URL(string: mediumCoverURL)
    }
    
    func getSmallCoverURL() -> URL? {
        guard let smallCoverURL = self.smallCoverURL else {
            return nil
        }
        return URL(string: smallCoverURL)
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
    
    func getId() -> String {
        return getISBNSerialString() + getFirstPublished() + getTitle()
    }
}
