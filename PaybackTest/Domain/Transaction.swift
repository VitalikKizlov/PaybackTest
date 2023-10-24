//
//  Transaction.swift
//  PaybackTest
//
//  Created by Vitalii Kizlov on 24.10.2023.
//

import Foundation

struct TransactionsResponse: Codable {
    let items: [Transaction]
}

struct Transaction: Codable, Identifiable, Hashable {
    let id = UUID()

    let partnerDisplayName: String
    let alias: Alias
    let category: Int
    let transactionDetail: TransactionDetail

    enum CodingKeys: String, CodingKey {
        case partnerDisplayName, alias, category, transactionDetail
    }
}

struct Alias: Codable, Hashable {
    let reference: String
}

struct TransactionDetail: Codable, Hashable {
    let description: String?
    let bookingDate: Date
    let value: TransactionDetailValue
}

struct TransactionDetailValue: Codable, Hashable {
    let amount: Int
    let currency: Currency
}

enum Currency: String, Codable {
    case pbp = "PBP"
}
