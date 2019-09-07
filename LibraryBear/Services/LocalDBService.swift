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

class LocalDBService {
    func cache(book: NonLocalBook, callback: LocalDBSuccessCallback) {
        guard let realm = getRealm() else {
            return
        }
        
        let newLocalBook = LocalBook(book: book)
        
        guard getBook(withId: book.getISBNSerialString()) == nil else {
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
    
    func getCachedBooks() -> [Book]? {
        guard let realm = getRealm() else {
            return nil
        }
        
        return realm.objects(LocalBook.self).map { localBook in
            return localBook
        }
    }
    
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
    
    private func getBook(withId id: String) -> Book? {
        guard let realm = getRealm() else {
            return nil
        }
        
        let results = realm.objects(LocalBook.self).filter("id = '\(id)'")
        return results.first
    }
}
