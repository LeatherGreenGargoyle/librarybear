//
//  GlobalFunctions.swift
//  LibraryBear
//
//  Created by Andrew Tran on 9/5/19.
//  Copyright © 2019 Andrew Tran. All rights reserved.
//

import Foundation

func mainThread(_ closure: @escaping () -> ()) {
    DispatchQueue.main.async(execute: closure)
}

func registerNotification(object: Any? = nil,
                          for name: Notification.Name,
                          _ callback: @escaping (Notification) -> Void) {
    NotificationCenter.default.addObserver(forName: name,
                                           object: object,
                                           queue: nil,
                                           using: callback)
}
