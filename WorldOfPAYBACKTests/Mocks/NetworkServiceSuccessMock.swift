//
//  NetworkServiceSuccessMock.swift
//  WorldOfPAYBACKTests
//

import Foundation
import Combine
@testable import WorldOfPAYBACK

final class NetworkServiceSuccessMock: Networking {
    func getAllTransactions(_ path: String, filter: NetworkFilter) -> AnyPublisher<[Transaction], Error> {
        let transactionDetails = TransactionDetails(
            description: nil,
            bookingDate: .now,
            value: TransactionValue(amount: 20.0, currency: "USD")
        )
        let transaction = Transaction(
            partnerDisplayName: "partner",
            category: 0,
            transactionDetail: transactionDetails
        )
        
        return Just([transaction])
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
