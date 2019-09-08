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

extension UIColor {
    class var gray: UIColor {
        return UIColor(red: 237.0 / 255.0, green: 237.0 / 255.0, blue: 237.0 / 255.0, alpha: 1.0)
    }
}

extension UIFont {
    class var regular10:  UIFont {
        return UIFont.systemFont(ofSize: 10.0, weight: UIFont.Weight.regular)
    }
    
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
    func showAlert(title: String,
                   message: String = "",
                   buttonTitle: String = "OK",
                   buttonHandler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .cancel, handler: buttonHandler ?? nil))
        present(alert, animated: true)
    }
}
