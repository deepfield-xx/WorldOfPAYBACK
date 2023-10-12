//
//  Transaction.swift
//  WorldOfPAYBACK
//

import Foundation

struct Transaction: Codable {
    let partnerDisplayName: String
    let category: Int
    let transactionDetail: TransactionDetails
}

struct Transactions : Codable {
    let items: [Transaction]
}
