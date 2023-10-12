//
//  NetworkServiceFailureMock.swift
//  WorldOfPAYBACKTests
//

import Foundation
import Combine
@testable import WorldOfPAYBACK

final class NetworkServiceFailureMock: Networking {
    func getAllTransactions(_ path: String, filter: NetworkFilter) -> AnyPublisher<[Transaction], Error> {
        return Fail(error: NetworkError.invalidServerResponse)
            .eraseToAnyPublisher()
    }
}
