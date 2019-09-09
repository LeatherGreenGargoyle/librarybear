//
//  LocalBook.swift
//  LibraryBear
//
//  Created by Andrew Tran on 9/6/19.
//  Copyright © 2019 Andrew Tran. All rights reserved.
//

import Foundation
import RealmSwift

/// A cached book object.
@objcMembers class LocalBook: Object, Book {

    @objc private dynamic var id: String!
    
    var authors: List<String> = List<String>()
    
    @objc dynamic var smallCoverURLString: String?
    
    @objc dynamic var mediumCoverURLString: String?
    
    @objc dynamic var largeCoverURLString: String?
    
    @objc dynamic var title: String = ""

    @objc dynamic var authorSerialString: String = ""
    
    @objc dynamic var firstPublished: String = ""
    
    @objc dynamic var isbnSerialString: String = ""
    
    @objc dynamic var contributorSerialString: String = ""
    
    @objc dynamic var numberOfEditions: String = ""
    
    @objc dynamic var publisherSerialString: String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(book: NonLocalBook) {
        self.init()
        
        id = book.getId()
        authors.append(objectsIn: book.authors)
        title = book.getTitle()
        authorSerialString = book.getAuthorSerialString()
        firstPublished = book.getFirstPublished()
        largeCoverURLString = book.largeCoverURL ?? ""
        mediumCoverURLString = book.mediumCoverURL ?? ""
        smallCoverURLString = book.smallCoverURL ?? ""
        isbnSerialString = book.getISBNSerialString()
        contributorSerialString = book.getContributorSerialString()
        numberOfEditions = book.getNumberOfEditions()
        publisherSerialString = book.getPublishersSerialString()
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
     Displays a comma-separated list of author names.
     
     - Returns: A comma-separated list.
     */
    func getAuthorSerialString() -> String {
        return authorSerialString
    }
    
    /**
     Displays a comma-separated list of ISBN numbers.
     
     - Returns: A comma-separated list.
     */
    func getISBNSerialString() -> String {
        return isbnSerialString
    }
    
    /**
     Displays a comma-separated list of contributors.
     
     - Returns: A comma-separated list.
     */
    func getContributorSerialString() -> String {
        return contributorSerialString
    }
    
    /**
     Displays a comma-separated list of publishers.
     
     - Returns: A comma-separated list.
     */
    func getPublishersSerialString() -> String {
        return publisherSerialString
    }
    
    func getLargeCoverURL() -> URL? {
        guard let largeCoverURLString = self.largeCoverURLString else {
            return nil
        }
        return URL(string: largeCoverURLString)
    }
    
    func getMediumCoverURL() -> URL? {
        guard let mediumCoverURLString = self.mediumCoverURLString else {
            return nil
        }
        return URL(string: mediumCoverURLString)
    }
    
    func getSmallCoverURL() -> URL? {
        guard let smallCoverURLString = self.smallCoverURLString else {
            return nil
        }
        return URL(string: smallCoverURLString)
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

