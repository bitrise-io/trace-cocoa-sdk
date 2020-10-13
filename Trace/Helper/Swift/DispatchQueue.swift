//
//  DispatchQueue.swift
//  Trace
//
//  Created by Shams Ahmed on 13/10/2020.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation

extension DispatchQueue {
    
    // MARK: - Property
            
    static var isMainQueue: Bool {
        enum StaticMainQueue {
            static let key: DispatchSpecificKey<Void> = {
                let key = DispatchSpecificKey<Void>()
               
                DispatchQueue.main.setSpecific(key: key, value: ())
                
                return key
            }()
        }
        
        return getSpecific(key: StaticMainQueue.key) != nil
    }
}
