//
//  TransactionListView.swift
//  WorldOfPAYBACK
//

import SwiftUI

struct TransactionListView: View {
    @StateObject private var networkMonitor = NetworkMonitor()
    @StateObject private var viewModel = TransactionListViewModel()
    @State private var presentDetails = false
    
    var body: some View {
        VStack {
            if networkMonitor.isConnected == false {
                noConnection
            }
            
            Spacer()
            
            switch viewModel.state {
            case .loading:
                loadingState
                
            case .loaded:
                loadedState
                
            case .error(let error):
                errorState(error)
            }
            
            Spacer()
        }
        .sheet(isPresented: $presentDetails, onDismiss: {
            presentDetails = false
        }, content: {
            TransactionDetailsView(
                partnerDisplayName: viewModel.selectedTransaction?.partnerDisplayName ?? "",
                description: viewModel.selectedTransaction?.transactionDetail.description)
        })
    }
    
    @ViewBuilder
    var noConnection: some View {
        HStack {
            Image(systemName: "wifi.slash")
                .font(.system(size: 12))
                .foregroundColor(.red)
            Text("no_connection")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.red)
        }
    }
    
    @ViewBuilder
    var loadingState: some View {
        ProgressView {
            Text("loading")
        }
    }
    
    @ViewBuilder
    var loadedState: some View {
        VStack {
            HStack {
                Spacer()
                Menu {
                    VStack {
                        ForEach(viewModel.filters, id: \.self) { filter in
                            Button {
                                viewModel.getTransactions(filter: filter)
                            } label: {
                                HStack {
                                    Text(filter.description)
                                    if viewModel.lastAppliedFilter == filter {
                                        Image(systemName: "checkmark")
                                            .font(.system(size: 12))
                                    }
                                }
                            }
                        }
                    }
                } label: {
                    Text("filter")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)
                        .frame(height: 44)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.transactions.indices, id: \.self) { index in
                        item(viewModel.transactions[index])
                    }
                }
            }
            .clipped()
            
            if viewModel.isFilterApplied {
                HStack {
                    Spacer()
                    Text("sum")
                        .font(.system(size: 22, weight: .bold))
                    Text(viewModel.getSumOfFilteredTransaction())
                        .font(.system(size: 22, weight: .bold))
                }
                .frame(height: 50)
                .padding(.horizontal, 20)
            }
        }
    }
    
    @ViewBuilder
    func errorState(_ error: Error) -> some View {
        VStack {
            Spacer()
            
            Image(systemName: "exclamationmark.circle")
                .font(.system(size: 40))
                .padding(.bottom, 20)
                .foregroundColor(.gray)
            Text(error.localizedDescription.description)
                .foregroundColor(.gray)
                .padding(.bottom, 20)
                .padding(.horizontal, 20)
                .multilineTextAlignment(.center)
            
            Button {
                viewModel.retryLastCall()
            } label: {
                Text("retry")
                    .font(.system(size: 20))
                    .foregroundColor(.blue)
            }

            
            Spacer()
        }
    }
    
    @ViewBuilder
    func item(_ transation: Transaction) -> some View {
        VStack {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 12) {
                    Text(transation.partnerDisplayName)
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.black)
                    Text(transation.transactionDetail.description ?? "-")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
                Spacer()
                
                VStack(alignment: .leading, spacing: 12) {
                    Text(viewModel.format(date:  transation.transactionDetail.bookingDate))
                        .font(.system(size: 10))
                        .foregroundColor(.black)
                    Text(viewModel.formatCurrency(value: transation.transactionDetail.value))
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.black)
                        .padding(.top, 10)
                }
            }
            .frame(height: 60)
            .padding(.horizontal, 16)
            
            Rectangle()
                .fill(.gray)
                .frame(height: 1)
                .opacity(0.3)
                .padding(.horizontal, 12)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            viewModel.selectedTransaction = transation
            presentDetails = true
        }
    }
}

struct TransactionListView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionListView()
    }
}
