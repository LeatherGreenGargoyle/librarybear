//
//  LibraryService.swift
//  LibraryBear
//
//  Created by Andrew Tran on 9/4/19.
//  Copyright © 2019 Andrew Tran. All rights reserved.
//

import Foundation

class LibraryService {
    
    enum CoverImageSize {
        case small, medium, large
    }
    
    private let KEY_AUTHOR_NAME = "author_name"
    private let KEY_CONTRIBUTOR = "contributor"
    private let KEY_COVER_EDITION_KEY = "cover_edition_key"
    private let KEY_DOCS = "docs"
    private let KEY_EDITION_COUNT = "edition_count"
    private let KEY_FIRST_PUBLISH_YEAR = "first_publish_year"
    private let KEY_ISBN = "isbn"
    private let KEY_PUBLISHER = "publisher"
    private let KEY_TITLE = "title"
    
    private let session = URLSession(configuration: .default)
    private var currentPagination = 1
    private var currentInput = ""
    
    func fetchResultsOf(searchInput: String, onErrorMessage: @escaping StringCallback) {
        guard searchInput.count > 0 else {
            return
        }
        
        let formattedInput = getQueryStringFrom(searchInput: searchInput)
        guard let url = URL(string: "http://openlibrary.org/search.json?q=\(formattedInput)") else {
            print("Error creating URL from input")
            return
        }
        print("Attempting to query input \(formattedInput)")
        
        let searchTask = session.dataTask(with: url) { (data, response, error) in
            if let unwrappedError = error {
                print("Error while fetching search results: \(unwrappedError.localizedDescription)")
                onErrorMessage("There was an issue with the server, please try again later.")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                return
            }
            guard (200...299).contains(httpResponse.statusCode) else {
                let errorMessage = self.getErrorMessageFrom(httpStatusCode: httpResponse.statusCode)
                onErrorMessage(errorMessage)
                return
            }
            guard let mime = httpResponse.mimeType, mime == "text/plain" else {
                print("Data was not in expected format")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String : Any]
                let booksRaw = json[self.KEY_DOCS] as? [[String : Any]] ?? []
                let books = booksRaw.map({ rawBook -> Book in
                    return self.getBookFrom(document: rawBook)
                })
                print("Data: \(books)")
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
        }
        
        searchTask.resume()
    }
    
    private func getQueryStringFrom(searchInput: String) -> String {
        return searchInput.replacingOccurrences(of: " ", with: "+") + "$page=\(currentPagination)"
    }
    
    private func getErrorMessageFrom(httpStatusCode: Int) -> String {
        switch httpStatusCode {
        case 500...599:
            return "There was an error with the server. Please try again later."
        case 400...499:
            return "Please check the format of your search and try again."
        default:
            return "Oops, there must be a bear attack at the library or something, please try again later."
        }
    }
    
    private func getBookFrom(document: [String: Any]) -> Book {
        let coverEditionKey = document[KEY_COVER_EDITION_KEY] as? String ?? ""
        let publishYearRaw = document[KEY_FIRST_PUBLISH_YEAR] as? Int
        let publishYearString = publishYearRaw != nil ? "\(publishYearRaw!)" : "n/a"
        let numberOfEditionsRaw = document[KEY_EDITION_COUNT] as? Int
        let numberOfEditionsString = numberOfEditionsRaw != nil ? "\(numberOfEditionsRaw!)" : "n/a"
        return Book(title: document[KEY_TITLE] as? String ?? "n/a",
                    author: (document[KEY_AUTHOR_NAME] as? [String])?.first ?? "n/a",
                    firstPublished: publishYearString,
                    largeCoverURL: getUrlFor(coverEditionKey: coverEditionKey, size: .large),
                    mediumCoverURL: getUrlFor(coverEditionKey: coverEditionKey, size: .medium),
                    smallCoverURL: getUrlFor(coverEditionKey: coverEditionKey, size: .small),
                    isbnNumbers: document[KEY_ISBN] as? [String] ?? [],
                    contributors: document[KEY_CONTRIBUTOR] as? [String] ?? [],
                    numberOfEditions: numberOfEditionsString,
                    publishers: document[KEY_PUBLISHER] as? [String] ?? [])
    }
    
    private func getUrlFor(coverEditionKey: String, size: CoverImageSize) -> String {
        switch size {
        case .small:
            return "https://covers.openlibrary.org/b/olid/\(coverEditionKey)-S.jpg"
        case .medium:
            return "https://covers.openlibrary.org/b/olid/\(coverEditionKey)-M.jpg"
        case .large:
            return "https://covers.openlibrary.org/b/olid/\(coverEditionKey)-L.jpg"
        }
    }
}

struct Book {
    let title: String
    let author: String
    let firstPublished: String
    let largeCoverURL: String
    let mediumCoverURL: String
    let smallCoverURL: String
    let isbnNumbers: [String]
    let contributors: [String]
    let numberOfEditions: String
    let publishers: [String]
}
