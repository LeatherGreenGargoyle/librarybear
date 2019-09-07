//
//  LocalBook.swift
//  LibraryBear
//
//  Created by Andrew Tran on 9/6/19.
//  Copyright © 2019 Andrew Tran. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class LocalBook: Object, Book {

    @objc private dynamic var id: String!
    
    var smallCoverURLString: String?
    
    var mediumCoverURLString: String?
    
    var largeCoverURLString: String?
    
    var title: String = ""

    var authorSerialString: String = ""
    
    var firstPublished: String = ""
    
    var isbnSerialString: String = ""
    
    var contributorSerialString: String = ""
    
    var numberOfEditions: String = ""
    
    var publisherSerialString: String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(book: Book) {
        self.init()
        
        id = book.getISBNSerialString()
        title = book.getTitle()
        authorSerialString = book.getAuthorSerialString()
        firstPublished = book.getFirstPublished()
        largeCoverURLString = book.getLargeCoverURL()?.absoluteString
        mediumCoverURLString = book.getMediumCoverURL()?.absoluteString
        smallCoverURLString = book.getSmallCoverURL()?.absoluteString
        isbnSerialString = book.getISBNSerialString()
        contributorSerialString = book.getContributorSerialString()
        numberOfEditions = book.getNumberOfEditions()
        publisherSerialString = book.getPublishersSerialString()
    }
    
    func getAuthorSerialString() -> String {
        return authorSerialString
    }
    
    func getISBNSerialString() -> String {
        return isbnSerialString
    }
    
    func getContributorSerialString() -> String {
        return contributorSerialString
    }
    
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
}

