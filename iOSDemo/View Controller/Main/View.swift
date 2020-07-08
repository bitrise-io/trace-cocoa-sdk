//
//  View.swift
//  iOSDemo
//
//  Created by Shams Ahmed on 20/06/2019.
//  Copyright © 2019 Bitrise. All rights reserved.
//

import Foundation
import UIKit

/// Example of using a normal view
final class View: UIView {
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        
    }
}
