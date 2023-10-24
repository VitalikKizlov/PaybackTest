//
//  ConnectionService.swift
//  PaybackTest
//
//  Created by Vitalii Kizlov on 24.10.2023.
//

import Network

final class ConnectionService {
    static func isConnected() async -> Bool{
        typealias Continuation = CheckedContinuation<Bool, Never>
        return await withCheckedContinuation({ (continuation: Continuation) in
            let monitor = NWPathMonitor()

            monitor.pathUpdateHandler = { path in
                monitor.cancel()
                switch path.status {
                case .satisfied:
                    continuation.resume(returning: true)
                case .unsatisfied, .requiresConnection:
                    continuation.resume(returning: false)
                @unknown default:
                    continuation.resume(returning: false)
                }
            }
            monitor.start(queue: DispatchQueue(label: "InternetConnectionMonitor"))
        })
    }
}
