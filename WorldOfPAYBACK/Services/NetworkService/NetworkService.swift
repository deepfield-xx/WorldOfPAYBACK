//
//  NetworkService.swift
//  WorldOfPAYBACK
//

import Foundation
import Combine

enum NetworkError: Error {
    case noConnection
    case invalidServerResponse
}

enum NetworkFilter: Int, CaseIterable {
    case none = 0
    case filter1 = 1
    case filter2 = 2
    case filter3 = 3
    
    var description: String {
        switch self {
        case .none:
            return String(localized: "none")
        case .filter1:
            return String(localized: "filter1")
        case .filter2:
            return String(localized: "filter2")
        case .filter3:
            return String(localized: "filter3")
        }
    }
}

final class NetworkService: Networking {
    private let baseURL: URL
    
    init(_ env: NetworkEnv) {
        baseURL = env.baseUrl
    }
    
    func getAllTransactions(_ path: String, filter: NetworkFilter) -> AnyPublisher<[Transaction], Error> {
        return request(path)
    }
    
    private func request<T: Codable>(_ path: String) -> AnyPublisher<T, Error> {
        let url = baseURL.appending(path: path)
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw NetworkError.invalidServerResponse
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
