//
//  Timeseriesble.swift
//  Trace
//
//  Created by Shams Ahmed on 24/08/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation

protocol Timeseriesble: Codable {
    
    // MARK: - Property
    
    var values: [Metric.Timeseries.Value] { get }
    var points: [Metric.Timeseries.Point] { get set }
}
