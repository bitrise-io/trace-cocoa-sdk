//
//  Connectivity.swift
//  Trace
//
//  Created by Shams Ahmed on 12/06/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation
import Network

#if canImport(SystemConfiguration)
import SystemConfiguration.CaptiveNetwork
#endif

internal protocol ConnectivitySupportProtocol {
    
    // MARK: - Interface
    
    var interface: Connectivity.Interface? { get }
}

internal extension Connectivity {

    // MARK: - PathMonitor iOS12+

    @available(iOS 12.0, *)
    final class PathMonitor: ConnectivitySupportProtocol {
        
        // MARK: - Property
        
        private let network = NWPathMonitor()
        
        internal var interface: Connectivity.Interface?
        
        // MARK: - Init
        
        internal init() {
            setup()
        }
        
        // MARK: - Setup
        
        private func setup() {
            network.pathUpdateHandler = { [weak self] path in
                self?.update(with: path)
            }
            
            network.start(queue: .global(qos: .background))
            
            update(with: network.currentPath)
        }
        
        // MARK: - Interface
        
        private func update(with path: NWPath) {
            if let availableInterface = path.availableInterfaces.first {
                switch availableInterface.type {
                case .cellular: interface = .cellular
                case .wifi: interface = .wifi
                default: break
                }
            }
        }
    }
    
    // MARK: - Reachability Pre iOS12
    
    final class Reachability: ConnectivitySupportProtocol {
        
        // MARK: - Init
        
        internal init() {
            setup()
        }
        
        // MARK: - Setup
        
        private func setup() {
            
        }
        
        // MARK: - Status
        
        internal var interface: Connectivity.Interface? {
            var flags: SCNetworkReachabilityFlags = []
            var address = sockaddr_in()
            address.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
            address.sin_family = sa_family_t(AF_INET)
            
            guard let route = withUnsafePointer(to: &address, {
                $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                    SCNetworkReachabilityCreateWithAddress(nil, $0)
                }
            }) else {
                return nil
            }
            
            if !SCNetworkReachabilityGetFlags(route, &flags) {
                return nil
            }
            
            let connectionRequired = flags.contains(.connectionRequired)
            let isReachable = flags.contains(.reachable)
            let isWWAN = flags.contains(.isWWAN)
            
            if !connectionRequired && isReachable {
                return isWWAN ? .cellular : .wifi
            }
            
            return nil
        }
    }
}

/// Connectivity - find all network details
internal struct Connectivity {
    
    // MARK: - Enum
    
    internal enum Interface: String {
        case wifi
        case cellular
    }
    
    // MARK: - Struct
    
    struct Result: Encodable {
        let interface: String?
        let timestamp: Time.Timestamp
    }
    
    // MARK: - Property
    
    private let network: ConnectivitySupportProtocol = {
        guard #available(iOS 12.0, *) else { return Reachability() }
        
        return PathMonitor()
    }()
    
    internal var interface: Result {
        return Result(interface: network.interface?.rawValue, timestamp: Time.timestamp)
    }
    
    // MARK: - Init
    
    internal init() {
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        
    }
}
