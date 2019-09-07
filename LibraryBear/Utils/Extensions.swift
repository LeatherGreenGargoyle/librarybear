//
//  Extensions.swift
//  LibraryBear
//
//  Created by Andrew Tran on 9/4/19.
//  Copyright © 2019 Andrew Tran. All rights reserved.
//
import UIKit

extension Array where Element == String {
    func getSerialString() -> String {
        var combinedString = "n/a"
        for (index, element) in self.enumerated() {
            if (index == 0) {
                combinedString = element
            } else if (index == self.count - 1) {
                combinedString += " and \(element)"
            } else {
                combinedString += ", \(element)"
            }
        }
        return combinedString
    }
}

extension UIFont {
    class var regular14:  UIFont {
        return UIFont.systemFont(ofSize: 14.0, weight: UIFont.Weight.regular)
    }
}

extension UIView {
    func addSubviews(_ views: [UIView]) {
        for view in views {
            self.addSubview(view)
        }
    }
}

extension UIViewController {
    func showAlert(title: String,
                   message: String = "",
                   buttonTitle: String = "OK",
                   buttonHandler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .cancel, handler: buttonHandler ?? nil))
        present(alert, animated: true)
    }
}
