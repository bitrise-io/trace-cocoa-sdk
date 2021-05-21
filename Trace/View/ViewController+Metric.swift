//
//  ViewController+Metric.swift
//  Trace
//
//  Created by Shams Ahmed on 16/09/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    // MARK: - Metric
    
    final class Metric: CustomStringConvertible {
        
        // MARK: - Property
        
        var observed = true
        
        var name: String = ""
        var `init`: Time.Timestamp?
        var initWithCoder: Time.Timestamp?
        var initWithNib: Time.Timestamp?
        var awakeFromNib: Time.Timestamp?
        var loadView: Time.Timestamp?
        var viewDidLoad: Time.Timestamp?
        var viewWillAppear: Time.Timestamp?
        var viewDidAppear: Time.Timestamp?
        var viewWillLayoutSubviews: Time.Timestamp?
        var viewDidLayoutSubviews: Time.Timestamp?
        var viewWillDisappear: Time.Timestamp?
        var viewDidDisappear: Time.Timestamp?
        var didReceiveMemoryWarning: Time.Timestamp?
        
        // MARK: - Helper
        
        var initTimeInterval: Double {
            var start: Double = 0.0
            
            if let value = `init` {
                start = value.timeInterval
            } else if let value = initWithCoder {
                start = value.timeInterval
            } else if let value = initWithNib {
                start = value.timeInterval
            } else if let value = awakeFromNib {
                start = value.timeInterval
            } else {
                Logger.error(.internalError, "Failed to find viewController(\(name)) start time")
            }
            
            return start
        }
        
        /// Time the view controller taking to appear.
        var viewRenderingLatency: Double {
            let start: Double = initTimeInterval
            var end = 0.0
            
            if let timeInterval = viewDidAppear?.timeInterval {
                end = timeInterval
            }
            
            if end == 0.0 {
                Logger.error(.internalError, "Failed to find viewController(\(name)) end time")
            }
            
            let result = end - start
            
            return result
        }
        
        // MARK: - Description
        
        var description: String {
            return "\(type(of: self)) - name: \(name) init: \(String(describing: `init`)), initWithCoder: \(String(describing: initWithCoder)), initWithNib: \(String(describing: initWithNib)), awakeFromNib: \(String(describing: awakeFromNib)), loadView: \(String(describing: loadView)), viewDidLoad: \(String(describing: viewDidLoad)), viewWillAppear: \(String(describing: viewWillAppear)), viewDidAppear: \(String(describing: viewDidAppear)), viewWillLayoutSubviews: \(String(describing: viewWillLayoutSubviews)), viewDidLayoutSubviews: \(String(describing: viewDidLayoutSubviews)), viewWillDisappear: \(String(describing: viewWillDisappear)), viewDidDisappear: \(String(describing: viewDidDisappear)), didReceiveMemoryWarning: \(String(describing: didReceiveMemoryWarning))"
        }
    }
}
