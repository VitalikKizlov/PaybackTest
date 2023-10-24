//
//  TransactionsService.swift
//  PaybackTest
//
//  Created by Vitalii Kizlov on 24.10.2023.
//

import Foundation
import Network
import ComposableArchitecture

struct TransactionsService {
    enum NetworkStatus {
        case available
        case unavailable
    }

    enum NetworkError: Error {
        case networkUnavailable
    }

    var getTransactions: () async throws -> [Transaction]
}

extension TransactionsService: DependencyKey {
    static let liveValue = Self {
        async let status = ConnectionService.isConnected()

        if await !status {
            throw NetworkError.networkUnavailable
        }

        async let response: TransactionsResponse = JSONParser.parseJSON("PBTransactions")
        try await Task.sleep(nanoseconds: 1_000_000_000)
        return try await response.items
    }
}

extension DependencyValues {
  var transactionsService: TransactionsService {
    get { self[TransactionsService.self] }
    set { self[TransactionsService.self] = newValue }
  }
}
