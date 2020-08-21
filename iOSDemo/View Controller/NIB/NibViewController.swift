//
//  NibViewController.swift
//  iOSDemo
//
//  Created by Shams Ahmed on 21/08/2020.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import UIKit

final class NibView: UIView {
    
}

final class NibViewController: UIViewController {
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - Setup
    
    private func setup() {
//        view.setValue("someValue", forUndefinedKey: "someKey")
    }
}
