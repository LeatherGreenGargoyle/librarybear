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
    
    static let PAGINATION_LIMIT = 100
    
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
    private var previousInput = ""
    
    func fetchMoreResults(onResult: @escaping BooksCallback, onErrorMessage: @escaping StringCallback) {
        guard previousInput.count > 0 else {
            print("No previous input during 'more' search")
            return
        }
        currentPagination += 1
        
        let formattedInput = getQueryStringFrom(
            searchInput: previousInput,
            currentPagination: currentPagination
        )

        print("About to query more results...")
        performSearch(formattedSearchString: formattedInput, onResult: onResult, onErrorMessage: onErrorMessage)
    }
    
    func fetchResultsOf(searchInput: String, onResult: @escaping BooksCallback, onErrorMessage: @escaping StringCallback) {
        guard searchInput.count > 0 else {
            return
        }
        previousInput = searchInput
        currentPagination = 1
        
        let formattedInput = getQueryStringFrom(
            searchInput: searchInput,
            currentPagination: currentPagination
        )
        
        print("About to query new results...")
        performSearch(formattedSearchString: formattedInput, onResult: onResult, onErrorMessage: onErrorMessage)
    }
    
    private func getBookFrom(document: [String: Any]) -> Book {
        let coverEditionKey = document[KEY_COVER_EDITION_KEY] as? String ?? ""
        let publishYearRaw = document[KEY_FIRST_PUBLISH_YEAR] as? Int
        let publishYearString = publishYearRaw != nil ? "\(publishYearRaw!)" : "n/a"
        let numberOfEditionsRaw = document[KEY_EDITION_COUNT] as? Int
        let numberOfEditionsString = numberOfEditionsRaw != nil ? "\(numberOfEditionsRaw!)" : "n/a"
        return Book(title: document[KEY_TITLE] as? String ?? "n/a",
                    authors: (document[KEY_AUTHOR_NAME] as? [String]) ?? [],
                    firstPublished: publishYearString,
                    largeCoverURL: getUrlFor(coverEditionKey: coverEditionKey, size: .large),
                    mediumCoverURL: getUrlFor(coverEditionKey: coverEditionKey, size: .medium),
                    smallCoverURL: getUrlFor(coverEditionKey: coverEditionKey, size: .small),
                    isbnNumbers: document[KEY_ISBN] as? [String] ?? [],
                    contributors: document[KEY_CONTRIBUTOR] as? [String] ?? [],
                    numberOfEditions: numberOfEditionsString,
                    publishers: document[KEY_PUBLISHER] as? [String] ?? [])
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
    
    private func getQueryStringFrom(searchInput: String, currentPagination: Int) -> String {
        return searchInput.replacingOccurrences(of: " ", with: "+") + "&page=\(currentPagination)"
    }
    
    private func getUrlFor(coverEditionKey: String, size: CoverImageSize) -> URL? {
        switch size {
        case .small:
            return URL(string: "https://covers.openlibrary.org/b/olid/\(coverEditionKey)-S.jpg")
        case .medium:
            return URL(string: "https://covers.openlibrary.org/b/olid/\(coverEditionKey)-M.jpg")
        case .large:
            return URL(string: "https://covers.openlibrary.org/b/olid/\(coverEditionKey)-L.jpg")
        }
    }
    
    private func performSearch(formattedSearchString: String, onResult: @escaping BooksCallback, onErrorMessage: @escaping StringCallback) {
        guard let url = URL(string: "http://openlibrary.org/search.json?q=\(formattedSearchString)") else {
            print("Error creating URL from input")
            return
        }
        print("Attempting to query input \(url)")
        
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
                onResult(books)
            } catch {
                print("JSON error: \(error.localizedDescription)")
                onErrorMessage("There was an issue with the server, please try again later.")
            }
        }
        
        searchTask.resume()
    }

}

struct Book {
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
    func getISBNSerialString() -> String {
        return isbnNumbers.getSerialString()
    }
    func getContributerSerialString() -> String {
        return contributors.getSerialString()
    }
    func getPublishersSerialString() -> String {
        return publishers.getSerialString()
    }
}
