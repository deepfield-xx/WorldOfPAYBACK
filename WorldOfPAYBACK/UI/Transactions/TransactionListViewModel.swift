//
//  TransactionListViewModel.swift
//  WorldOfPAYBACK
//

import Foundation
import Combine

enum TransactionListViewModelState {
    case loading
    case loaded
    case error(Error)
}

final class TransactionListViewModel: ObservableObject {
    @Dependency private var networking: Networking
    @Published var state = TransactionListViewModelState.loading
    
    private(set) var transactions = [Transaction]()
    
    private let dateFormatter = DateFormatter()
    private var cancellables = Set<AnyCancellable>()
    
    var isFilterApplied = false
    var lastAppliedFilter = NetworkFilter.none
    var selectedTransaction: Transaction?
    
    var filters: [NetworkFilter] {
        return NetworkFilter.allCases
    }
    
    init() {
        dateFormatter.setLocalizedDateFormatFromTemplate("dd MMM yyyy, hh:mm")
        
        getTransactions()
    }
    
    func getTransactions(filter: NetworkFilter = .none) {
        isFilterApplied = filter != .none
        lastAppliedFilter = filter
        
        state = .loading
        networking.getAllTransactions("", filter: filter)
            .sink { cmp in
                switch cmp {
                case .finished:
                    break
                case .failure(let error):
                    self.state = .error(error)
                }
            } receiveValue: { transactions in
                self.transactions = transactions
                self.state = .loaded
            }
            .store(in: &cancellables)
    }
    
    func retryLastCall() {
        getTransactions(filter: lastAppliedFilter)
    }
    
    func format(date: Date) -> String {
        return dateFormatter.string(from: date)
    }
    
    func formatCurrency(value: TransactionValue) -> String {
        return value.amount
            .formatted(.currency(code: value.currency)
            .locale(Locale.current))
    }
    
    func getSumOfFilteredTransaction() -> String {
        let sum = transactions
            .map { $0.transactionDetail.value.amount }
            .reduce(0, +)
        if let currency = transactions.first?.transactionDetail.value.currency {
            return sum
                .formatted(.currency(code: currency)
                .locale(Locale.current))
        } else {
            return ""
        }
        
    }
}
