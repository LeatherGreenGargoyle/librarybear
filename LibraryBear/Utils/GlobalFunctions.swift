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
