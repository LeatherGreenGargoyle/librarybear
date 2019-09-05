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

class BaseViewController<V: UIView>: UIViewController {
    var mainView                    = V()
    
    required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    
    init() { super.init(nibName: nil, bundle: nil) }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.view.addSubview(mainView)
        
        mainView.snp.makeConstraints { maker in
            maker.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
}
