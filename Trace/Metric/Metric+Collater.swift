//
//  Metric+Collater.swift
//  Trace
//
//  Created by Shams Ahmed on 18/08/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation

extension Metric {
    
    // MARK: - Collater
    
    struct Collater {
        
        // MARK: - Property
        
        private let timeseries: [Timeseries]
        
        // MARK: - Init
        
        init(_ timeseries: [Timeseries]) {
            self.timeseries = timeseries
            
            setup()
        }
        
        // MARK: - Setup
        
        private func setup() {
            
        }
        
        // MARK: - Collate
        
        // Over short period of time, hundreds of timeseries can be captured
        // To save weight matching series are collated together
        func collate() -> [Timeseries] {
            let grouped = timeseries.reduce([Timeseries]()) { result, timeseries in
                var result = result
                
                // check existing
                guard let index = result.firstIndex(where: { $0.values == timeseries.values }) else {
                    // add new
                    result.append(timeseries)
                    
                    return result
                }
                
                // update to existing
                result[index].points.append(contentsOf: timeseries.points)
                
                return result
            }
            
            return grouped
        }
    }
}
