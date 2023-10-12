//
//  NetworkServiceMock.swift
//  WorldOfPAYBACK
//

import Foundation
import Combine

final class NetworkServiceMock: Networking {
    private let decoder = JSONDecoder()
    
    init() {
        let dateFromater = DateFormatter()
        dateFromater.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        decoder.dateDecodingStrategy = .formatted(dateFromater)
    }
    
    func getAllTransactions(_ path: String, filter: NetworkFilter) -> AnyPublisher<[Transaction], Error> {
        return Just(())
            .delay(for: .seconds(Int.random(in: 1...3)), scheduler: RunLoop.main)
            .flatMap { _ -> AnyPublisher<(), Error> in
                if Int.random(in: 1...10) < 5 {
                    return Fail(error: NetworkError.invalidServerResponse)
                        .eraseToAnyPublisher()
                } else {
                    return Just(())
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                }
            }
            .flatMap { _ -> AnyPublisher<Data, Error> in
                if let filepath = Bundle.main.url(forResource: "PBTransactions", withExtension: "json") {
                    do {
                        let contents = try Data(contentsOf: filepath)
                        return Just(contents)
                            .setFailureType(to: Error.self)
                            .eraseToAnyPublisher()
                    } catch {
                        return Fail(error: error)
                            .eraseToAnyPublisher()
                    }
                } else {
                    return Just(Data())
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                }
            }
            .decode(type: Transactions.self, decoder: decoder)
            .map { transactions in
                var transactionsItems = transactions.items
                if filter != .none {
                    transactionsItems = transactionsItems.filter { $0.category == filter.rawValue }
                }
                
                transactionsItems = transactionsItems.sorted(by: { $0.transactionDetail.bookingDate > $1.transactionDetail.bookingDate })
                
                return transactionsItems
            }
            .eraseToAnyPublisher()
    }
}
