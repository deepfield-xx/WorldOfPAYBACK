//
//  WorldOfPAYBACKApp.swift
//  WorldOfPAYBACK
//

import SwiftUI

@main
struct WorldOfPAYBACKApp: App {
    
    init() {
        DependencyContainer.register(NetworkServiceMock() as Networking)
    }
    
    var body: some Scene {
        WindowGroup {
            TransactionListView()
        }
    }
}
