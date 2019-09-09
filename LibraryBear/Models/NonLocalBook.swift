//
//  Book.swift
//  LibraryBear
//
//  Created by Andrew Tran on 9/6/19.
//  Copyright © 2019 Andrew Tran. All rights reserved.
//

import Foundation

/// A protocol defining all necessary behavior for displaying book information.
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

/// A non-cached book object.
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
    
    /**
     Displays only the first two listed authors, with 'et al' attached if there are more than two.
     
     - Returns: An abbreviated string describing only the first two authors of a book.
     */
    func getAbbreviatedAuthorSerialString() -> String {
        if let firstAuthor = authors.first, authors.count > 2 {
            return "\(firstAuthor), et al"
        } else {
            return getAuthorSerialString()
        }
    }
    
    /**
     Displays a comma-separated list of ISBN numbers
     
     - Returns: A comma-separated list.
     */
    func getISBNSerialString() -> String {
        return isbnNumbers.getSerialString()
    }
    
    /**
     Displays a comma-separated list of contributor names.
     
     - Returns: A comma-separated list.
     */
    func getContributorSerialString() -> String {
        return contributors.getSerialString()
    }
    
    /**
     Displays a comma-separated list of publisher names.
     
     - Returns: A comma-separated list.
     */
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
    
    /**
     Gives a unique identifier for this book composed of the book ISBN, publish date, and title.
     
     - Returns: A unique identifier string.
     */
    func getId() -> String {
        return getISBNSerialString() + getFirstPublished() + getTitle()
    }
}
