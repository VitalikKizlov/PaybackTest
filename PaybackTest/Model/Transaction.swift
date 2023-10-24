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

struct Transaction: Codable {
    let partnerDisplayName: String
    let alias: Alias
    let category: Int
    let transactionDetail: TransactionDetail
}

struct Alias: Codable {
    let reference: String
}

struct TransactionDetail: Codable {
    let description: String?
    let bookingDate: Date
    let value: TransactionDetailValue
}

struct TransactionDetailValue: Codable {
    let amount: Int
    let currency: Currency
}

enum Currency: String, Codable {
    case pbp = "PBP"
}
