//
//  TransactionDetails.swift
//  WorldOfPAYBACK
//

import Foundation

struct TransactionDetails: Codable {
    let description: String?
    let bookingDate: Date
    let value: TransactionValue
}
