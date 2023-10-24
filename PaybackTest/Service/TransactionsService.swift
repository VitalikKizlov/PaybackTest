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
    func getTransactions() async throws -> [Transaction] {
        async let status = ConnectionService.isConnected()

        if await !status {
            throw NetworkError.networkUnavailable
        }

        async let response: TransactionsResponse = parseJSON("PBTransactions")
        try await Task.sleep(nanoseconds: 2_000_000_000)
        return try await response.items
    }

    enum NetworkStatus {
        case available
        case unavailable
    }

    enum NetworkError: Error {
        case networkUnavailable
    }

    private func parseJSON<T: Decodable>(_ fileName: String, fileExtension: String = "json") throws -> T {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: fileExtension) else {
            throw NSError(domain: NSURLErrorDomain, code: NSURLErrorResourceUnavailable)
        }
        
        let data = try Data(contentsOf: url)
        
        return try dateJSONDecoder.decode(T.self, from: data)
    }
}

let dateJSONDecoder: JSONDecoder = {
    let decoder = JSONDecoder()

    let formatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

        return dateFormatter
    }()

    decoder.dateDecodingStrategy = .formatted(formatter)

    return decoder
}()

extension TransactionsService: DependencyKey {
    static let liveValue = TransactionsService()
}

extension DependencyValues {
  var transactionsService: TransactionsService {
    get { self[TransactionsService.self] }
    set { self[TransactionsService.self] = newValue }
  }
}
