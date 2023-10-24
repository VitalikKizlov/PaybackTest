//
//  TransactionsService.swift
//  PaybackTest
//
//  Created by Vitalii Kizlov on 24.10.2023.
//

import Foundation
import Network
import ComposableArchitecture

protocol TransactionsServiceProtocol {
    func getTransactions() async throws -> [Transaction]
}

struct TransactionsService: TransactionsServiceProtocol {
    enum NetworkStatus {
        case available
        case unavailable
    }

    enum NetworkError: Error {
        case networkUnavailable
    }

    func getTransactions() async throws -> [Transaction] {
        async let status = ConnectionService.isConnected()

        if await !status {
            throw NetworkError.networkUnavailable
        }

        async let response: TransactionsResponse = JSONParser.parseJSON("PBTransactions")
        try await Task.sleep(nanoseconds: 1_000_000_000)
        return try await response.items
    }
}

extension TransactionsService: DependencyKey {
    static let liveValue = TransactionsService()
}

extension DependencyValues {
  var transactionsService: TransactionsService {
    get { self[TransactionsService.self] }
    set { self[TransactionsService.self] = newValue }
  }
}
