//
//  LocalDBService.swift
//  LibraryBear
//
//  Created by Andrew Tran on 9/5/19.
//  Copyright © 2019 Andrew Tran. All rights reserved.
//

import Foundation
import RealmSwift

enum LocalDBError: String {
    case alreadySaved
    case failedToSave
    case failedToDelete
}

/// A Service class handling the caching of NonLocalBook objects, and uncaching / retrieval of LocalBook objects.
class LocalDBService {
    /**
     Saves the provided book to the local database.
     
     - Parameters:
        - book: The NonLocalBook object to save
        - callback: A callback accepting an array of Book results
     - onErrorMessage: A callback accepting a success boolean and optional error type.
     */
    func cache(book: NonLocalBook, callback: LocalDBSuccessCallback) {
        guard let realm = getRealm() else {
            return
        }
        
        let newLocalBook = LocalBook(book: book)
        
        guard getBook(withId: book.getId()) == nil else {
            callback(false, .alreadySaved)
            return
        }
        
        do {
            try realm.write {
                realm.add(newLocalBook, update: .all)
                callback(true, nil)
            }
        } catch {
            print(error.localizedDescription)
            callback(false, .failedToSave)
        }
    }
    
    /**
     Retrieves all cached books from the local database.
     
     - Returns: An array of all cached books.
     */
    func getCachedBooks() -> [Book]? {
        guard let realm = getRealm() else {
            return nil
        }
        
        return realm.objects(LocalBook.self).map { localBook in
            return localBook
        }
    }
    
    /**
     Retrieves a cached Book with the provided ID.
     
     - Parameters:
        - withId: The string ID of the specified book.
     */
    func getBook(withId id: String) -> Book? {
        guard let realm = getRealm() else {
            return nil
        }
        
        let results = realm.objects(LocalBook.self).filter("id = '\(id)'")
        return results.first
    }
    
    /**
     Removes the provided book from the local database.
     
     - Parameters:
     - book: The book to remove
     - callback: A callback accepting a success/failure boolean and optional error type.
     */
    func removeCached(book: LocalBook, callback: LocalDBSuccessCallback) {
        guard let realm = getRealm() else {
            return
        }
        
        do {
            try realm.write() {
                realm.delete(book)
                callback(true, nil)
            }
        } catch {
            print("Error removing cached book: \(error.localizedDescription)")
            callback(false, .failedToDelete)
        }
    }
    
    private func getRealm() -> Realm? {
        do {
             return try Realm()
        } catch {
            print("Error attempting to instantiate Realm \(error.localizedDescription)")
            return nil
        }
    }
}
