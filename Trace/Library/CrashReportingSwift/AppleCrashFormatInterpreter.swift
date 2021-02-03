//
//  AppleCrashFormatInterpreter.swift
//  Trace
//
//  Created by Shams Ahmed on 07/04/2020.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation

/// Helper to read apple crash report and extract data
internal struct AppleCrashFormatInterpreter {
    
    // MARK: - Typealias
    
    internal typealias Result = Swift.Result<Model, Swift.Error>
    
    // MARK: - Model
    
    internal struct Model {
        
        // MARK: - Property
        
        var id = ""
        var timestamp = ""
        var appVersion = ""
        var buildVersion = ""
        var osVersion = ""
        var deviceType = ""
        var sessionId = ""
        var eventIdentifier = ""
        var network = ""
        var carrier = ""
        var deviceId = ""
        var title = ""
    }
    
    // MARK: - Enum
    
    internal enum Error: Swift.Error {
        case couldNotParseData
    }
    
    /// Regex: Patten match apple format structure
    private enum Patten: String, CaseIterable {
        case id = "\\w*Trace Id: \\w*"
        case timestamp = "\\w*Date\\/Time:.*[0.9]"
        case appVersion = "\\w*App Version:.*"
        case buildVersion = "\\w*Build Version:.*"
        case osVersion = "\\w*OS Version:.* "
        case deviceType = "\\w*\"device.type\": .*\""
        case sessionId = "\\w*\"app.session.id\": .*\""
        case eventIdentifier = "\\w*SDK Event Identifier: .*"
        case network = "\\w*\"device.network\": \".*\""
        case carrier = "\\w*\"device.carrier\": \".*\""
        case deviceId = "\\w*\"device.id\": \".*\""
        case exceptionType = "\\w*Exception Type:.*"
    }
    
    // MARK: - Property
    
    private let data: Data
    
    // MARK: - Init
    
    internal init(_ data: Data) {
        self.data = data
    }
    
    // MARK: - Formatting
    
    internal func toModel() -> Result {
        // All apple formatted file are plain text
        guard let string = String(data: data, encoding: .utf8), !string.isEmpty else {
            return .failure(Error.couldNotParseData)
        }
        
        do {
            let model = try Patten.allCases.reduce(into: Model()) { model, patten in
                // Use RegX to try find the data in the field
                let regx = try NSRegularExpression(pattern: patten.rawValue)
                let result = regx.firstMatch(
                    in: string,
                    options: .reportCompletion,
                    range: NSRange(location: 0, length: string.count)
                )
                
                if let range = result?.range {
                    let start = string.index(string.startIndex, offsetBy: range.location)
                    let end = string.index(start, offsetBy: range.length)
                    let swiftRange = start..<end
                    let value = String(string[swiftRange])
                    
                    // Assign value without doing any validation as trace id can't always be guaranteed
                    switch patten {
                    case .id:
                        model.id = value.replacingOccurrences(of: "Trace Id: ", with: "")
                    case .timestamp:
                        model.timestamp = value.replacingOccurrences(of: "Date/Time:       ", with: "")
                    case .appVersion:
                        model.appVersion = value.replacingOccurrences(of: "App Version:         ", with: "")
                    case .buildVersion:
                        model.buildVersion = value.replacingOccurrences(of: "Build Version:         ", with: "")
                    case .osVersion:
                        model.osVersion = value
                            .trimmingCharacters(in: CharacterSet.decimalDigits.inverted)
                    case .deviceType:
                        model.deviceType = value
                            .replacingOccurrences(of: "\"device.type\": \"", with: "")
                            .replacingOccurrences(of: "\"", with: "")
                    case .sessionId:
                        model.sessionId = value
                            .replacingOccurrences(of: "\"app.session.id\": \"", with: "")
                            .replacingOccurrences(of: "\"", with: "")
                    case .eventIdentifier:
                        model.eventIdentifier = value.replacingOccurrences(of: "SDK Event Identifier: ", with: "")
                    case .network:
                        model.network = value
                            .replacingOccurrences(of: "\"device.network\": \"", with: "")
                            .replacingOccurrences(of: "\"", with: "")
                    case .carrier:
                        model.carrier = value
                            .replacingOccurrences(of: "\"device.carrier\": \"", with: "")
                            .replacingOccurrences(of: "\"", with: "")
                    case .deviceId:
                        model.deviceId = value
                            .replacingOccurrences(of: "\"device.id\": \"", with: "")
                            .replacingOccurrences(of: "\"", with: "")
                    case .exceptionType:
                        model.title = value.replacingOccurrences(of: "Exception Type:  ", with: "")
                    }
                }
            }
            
            return .success(model)
        } catch {
            Logger.error(.crash, "Failed to create model from Apple format crash")
            
            return .failure(error)
        }
    }
}
