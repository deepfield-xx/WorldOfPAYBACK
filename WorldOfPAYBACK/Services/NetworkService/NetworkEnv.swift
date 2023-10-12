//
//  NetworkEnv.swift
//  WorldOfPAYBACK
//

import Foundation

enum NetworkEnv {
    case test
    case prod
    
    var baseUrl: URL {
        switch self {
        case .test:
            return URL(string: "https://api-test.payback.com/transactions")!
        case .prod:
            return URL(string: "https://api.payback.com/transactions")!
        }
    }
}
