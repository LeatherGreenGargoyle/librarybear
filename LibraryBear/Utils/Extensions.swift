//
//  Extensions.swift
//  LibraryBear
//
//  Created by Andrew Tran on 9/4/19.
//  Copyright © 2019 Andrew Tran. All rights reserved.
//
import UIKit

extension Array where Element == String {
    /**
     Helper function formatting the given string as a comma-separated list.
     
     - Returns: A comma-separated list
     */
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

extension UIColor {
    class var lbBrown: UIColor {
        return UIColor(red: 156.0 / 255.0, green: 103.0 / 255.0, blue: 11.0 / 255.0, alpha: 1.0)
    }
    class var lbGray: UIColor {
        return UIColor(red: 237.0 / 255.0, green: 237.0 / 255.0, blue: 237.0 / 255.0, alpha: 1.0)
    }
    class var lbGreen: UIColor {
        return UIColor(red: 69.0 / 255.0, green: 99.0 / 255.0, blue: 57.0 / 255.0, alpha: 1.0)
    }
}

extension UIFont {
    class var regular10:  UIFont {
        return UIFont.systemFont(ofSize: 10.0, weight: UIFont.Weight.regular)
    }
    
    class var regular14:  UIFont {
        return UIFont.systemFont(ofSize: 14.0, weight: UIFont.Weight.regular)
    }
    
    class var bold18:  UIFont {
        return UIFont.systemFont(ofSize: 18.0, weight: UIFont.Weight.bold)
    }
}

extension UIView {
    func addSubviews(_ views: [UIView]) {
        for view in views {
            self.addSubview(view)
        }
    }
    
    /**
     Rounds the specified corners of the given view. Should be called in layoutSubviews, or when the
     specified view's frame is available.
     
     - Parameters:
        - _: The corners which should be rounded
        - radius: The desired corner radius
     */
    func setRoundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}

extension UIViewController {
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    /**
     Helper function which uses a TapGestureRecognizer to dismiss any displayed keyboards on screen tap.
     */
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                 action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    /**
     Helper function which displays an alert with title, message, optional button title, and optional button
     handler.
     
     - Parameters:
        - title: The alert title
        - message: The alert message
        - buttonTitle: The button title
        - buttonHandler: A callback for the button
     */
    func showAlert(title: String,
                   message: String = "",
                   buttonTitle: String = "OK",
                   buttonHandler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .cancel, handler: buttonHandler ?? nil))
        present(alert, animated: true)
    }
}
