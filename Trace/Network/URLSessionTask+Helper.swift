//
//  URLSessionTask+Helper.swift
//  Trace
//
//  Created by Shams Ahmed on 27/08/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation

extension URLSessionTask {
    
    // MARK: - Enum
    
    private struct AssociatedKey {
        static var startDate = "br_startDate"
        static var endDate = "br_endDate"
    }
    
    // MARK: - Property
    
    /// Timestamp on when a requet was started i.e resume
    var startDate: Time.Timestamp? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.startDate) as? Time.Timestamp
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.startDate, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    /// Timestamp on when a requet was stopped i.e suspended or completed
    var endDate: Time.Timestamp? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.endDate) as? Time.Timestamp
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.endDate, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}
