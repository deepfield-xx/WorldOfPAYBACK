//
//  WorldOfPAYBACKTests.swift
//  WorldOfPAYBACKTests
//

import XCTest
@testable import WorldOfPAYBACK

final class WorldOfPAYBACKTests: XCTestCase {
    func testTransactionViewModelErrorState() {
        DependencyContainer.register(NetworkServiceFailureMock() as Networking)
        let viewModel = TransactionListViewModel()
        
        if case TransactionListViewModelState.error(let error) = viewModel.state {
            XCTAssertEqual(error as? NetworkError, NetworkError.invalidServerResponse)
        } else {
            XCTFail()
        }
    }
    
    func testTransactionViewModelSuccessState() {
        DependencyContainer.register(NetworkServiceSuccessMock() as Networking)
        let viewModel = TransactionListViewModel()
        
        if case TransactionListViewModelState.loaded = viewModel.state {
            XCTAssertEqual(viewModel.transactions.count, 1)
        } else {
            XCTFail()
        }
    }
}
