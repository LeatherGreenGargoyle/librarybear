//
//  LibraryService.swift
//  LibraryBear
//
//  Created by Andrew Tran on 9/4/19.
//  Copyright © 2019 Andrew Tran. All rights reserved.
//

import Foundation

/// A service object handling book queries, and conversion of result data into readable formats.
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
    
    /**
     Repeats the last-input search string with incremented pagination.
     
     - Parameters:
        - onResult: A callback accepting an array of Book results
        - onErrorMessage: A callback accepting an error message.
     */
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
    
    /**
     Initiates a query to the openLibrary API using the provided search string.
     
     - Parameters:
        - onResult: A callback accepting an array of Book results
        - onErrorMessage: A callback accepting an error message.
     
     - Returns: A comma-separated list.
     */
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
    
    // TODO: handle long string arrays.
    /**
     Converts a result dictionary into a readable Book object. This will truncate excessively-long string
     arrays which would complicate caching via Realm, and save missing data as "n/a".
     
     - Parameters:
        - document: A dictionary retrieved from the result data from openLibrary
     
     - Returns: A formatted book object.
     */
    private func getBookFrom(document: [String: Any]) -> Book {
        let coverEditionKey = document[KEY_COVER_EDITION_KEY] as? String ?? ""
        let publishYearRaw = document[KEY_FIRST_PUBLISH_YEAR] as? Int
        let publishYearString = publishYearRaw != nil ? "\(publishYearRaw!)" : "n/a"
        let numberOfEditionsRaw = document[KEY_EDITION_COUNT] as? Int
        let numberOfEditionsString = numberOfEditionsRaw != nil ? "\(numberOfEditionsRaw!)" : "n/a"
        
        let truncatedISBNNumbers = Array((document[KEY_ISBN] as? [String] ?? []).prefix(100))
        let truncatedAuthors = Array((document[KEY_AUTHOR_NAME] as? [String] ?? []).prefix(100))
        let truncatedContributors = Array((document[KEY_CONTRIBUTOR] as? [String] ?? []).prefix(100))
        let truncatedPublishers = Array((document[KEY_CONTRIBUTOR] as? [String] ?? []).prefix(100))
        
        return NonLocalBook(title: document[KEY_TITLE] as? String ?? "n/a",
                    authors: truncatedAuthors,
                    firstPublished: publishYearString,
                    largeCoverURL: getUrlFor(coverEditionKey: coverEditionKey, size: .large),
                    mediumCoverURL: getUrlFor(coverEditionKey: coverEditionKey, size: .medium),
                    smallCoverURL: getUrlFor(coverEditionKey: coverEditionKey, size: .small),
                    isbnNumbers: truncatedISBNNumbers,
                    contributors: truncatedContributors,
                    numberOfEditions: numberOfEditionsString,
                    publishers: truncatedPublishers
        )
    }
    
    /**
     Given a non-200 response code, will return an appropriate descriptive message.
     
     - Parameters:
        - httpStatusCode: A http response status code.
     
     - Returns: A string describing the provided error code.
     */
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
    
    /**
     Produces a string URL containing a general query at a particular pagination index.
     
     - Parameters:
        - searchInput: The input search string.
        - currentPagination: The pagination offset for the desired search results.
     
     - Returns: A string URL for the provided query
     */
    private func getQueryStringFrom(searchInput: String, currentPagination: Int) -> String {
        return searchInput.replacingOccurrences(of: " ", with: "+") + "&page=\(currentPagination)"
    }
    
    /**
     Produces a string URL pointing to a cover image for the specified book, of the specified size.
     
     - Parameters:
        - coverEditionKey: A unique key for a particular book edition for which there is a cover
     
     - Returns: A string URL pointing to the desired cover image
     */
    private func getUrlFor(coverEditionKey: String, size: CoverImageSize) -> String? {
        switch size {
        case .small:
            return "https://covers.openlibrary.org/b/olid/\(coverEditionKey)-S.jpg"
        case .medium:
            return "https://covers.openlibrary.org/b/olid/\(coverEditionKey)-M.jpg"
        case .large:
            return "https://covers.openlibrary.org/b/olid/\(coverEditionKey)-L.jpg"
        }
    }
    
    /**
     A helper function performing the actual http request to the openLibrary API.
     
     - Parameters:
        - formattedSearchString: The provided search string.
        - onResult: A callback accepting an array of Book results
        - onErrorMessage: A callback accepting an error message.
     */
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
