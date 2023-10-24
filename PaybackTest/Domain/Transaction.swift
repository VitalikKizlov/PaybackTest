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
    let id: UUID
    let partnerDisplayName: String
    let alias: Alias
    let category: Int
    let transactionDetail: TransactionDetail

    init(id: UUID, partnerDisplayName: String, alias: Alias, category: Int, transactionDetail: TransactionDetail) {
        self.id = id
        self.partnerDisplayName = partnerDisplayName
        self.alias = alias
        self.category = category
        self.transactionDetail = transactionDetail
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.partnerDisplayName = try container.decode(String.self, forKey: .partnerDisplayName)
        self.alias = try container.decode(Alias.self, forKey: .alias)
        self.category = try container.decode(Int.self, forKey: .category)
        self.transactionDetail = try container.decode(TransactionDetail.self, forKey: .transactionDetail)
        
        self.id = UUID()
    }

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

extension Transaction {
    static let uuid = UUID(uuidString: "BE3B5CC6-1C8A-45D1-9729-8FB796F52C28")!
    static let date = Date(timeIntervalSinceReferenceDate: -123456789.0)
    static let test = Self(id: uuid, partnerDisplayName: "", alias: Alias(reference: ""), category: 1, transactionDetail: TransactionDetail(description: "", bookingDate: date, value: TransactionDetailValue(amount: 1, currency: .pbp)))
}
