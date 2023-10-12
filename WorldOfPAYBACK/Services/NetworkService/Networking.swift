//
//  Networking.swift
//  WorldOfPAYBACK
//

import Foundation
import Combine

protocol Networking {
    func getAllTransactions(_ path: String, filter: NetworkFilter) -> AnyPublisher<[Transaction], Error>
}
