//
//  NetworkMonitor.swift
//  WorldOfPAYBACK
//

import Foundation
import Network

final class NetworkMonitor: ObservableObject {
    enum ConnectionType {
        case connected
        case expensive
        case notConnected
    }
    
    @Published private(set) var isConnected: Bool = false
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global()
    private var currentPathStatus: NWPath.Status?
    
    init() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            print("CONNECTION updated: \(path.status)")
            guard self?.currentPathStatus != path.status else { return }
            self?.currentPathStatus = path.status
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
            }
        }
        currentPathStatus = monitor.currentPath.status
    }
    
    public func check() -> ConnectionType {
        if monitor.currentPath.isExpensive {
            return .expensive
        } else if monitor.currentPath.status == .satisfied {
            return .connected
        } else {
            return .notConnected
        }
    }
}
