//
//  BaseViewController.swift
//  LibraryBear
//
//  Created by Andrew Tran on 9/4/19.
//  Copyright © 2019 Andrew Tran. All rights reserved.
//

import Foundation
import SnapKit
import UIKit

/// A base class with an associated generic mainView, with default white background color, and helper
/// functions to deal with proper keyboard UI.
class BaseViewController<V: UIView>: UIViewController {
    private let KEYBOARD_OFFSET     = UIScreen.main.bounds.height * 0.39
    
    var mainView = V()
    var keyboardPresented = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(mainView)
        
        hideKeyboardWhenTappedAround()
        
        mainView.snp.makeConstraints { maker in
            maker.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        registerNotification(for: UIResponder.keyboardWillShowNotification, keyboardWillShow)
        registerNotification(for: UIResponder.keyboardWillHideNotification, keyboardWillHide)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: self.view.window)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: self.view.window)
    }
    
    //MARK: - Overrides
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    /**
     Adjusts the current view to accommodate the space taken up by the appearance of the keyboard.
     
     - Parameters:
        - notification: The Notification object triggering this method
     */
    func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 && !keyboardPresented {
                self.view.frame.origin.y -= keyboardSize.height - KEYBOARD_OFFSET
                self.keyboardPresented = true
            }
        }
    }
    
    /**
     Adjusts the current view to accommodate the new space produced by the hiding of the keyboard.
     
     - Parameters:
        - notification: The Notification object triggering this method
     */
    func keyboardWillHide(notification: Notification) {
        if self.view.frame.origin.y != 0 && keyboardPresented {
            self.view.frame.origin.y = 0
            mainView.snp.updateConstraints { maker in
                maker.edges.equalTo(self.view.safeAreaLayoutGuide)
            }
            keyboardPresented = false
        }
    }
}

