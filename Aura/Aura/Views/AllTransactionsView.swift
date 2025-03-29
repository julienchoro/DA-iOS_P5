//
//  AllTransactionsView.swift
//  Aura
//
//  Created by Julien Choromanski on 29/03/2025.
//

import SwiftUI

struct AllTransactionsView: View {
    // View model that manages transactions data and state
    @ObservedObject var viewModel: AllTransactionsViewModel

    var body: some View {
        VStack {
            // Show loading indicator while fetching data
            if viewModel.isLoading {
                ProgressView("Loading transactions...")
                    .padding()
            }
            // Display error message if something went wrong
            else if let errorMessage = viewModel.errorMessage {
                VStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.red)
                        .padding(.bottom, 5)
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
            }
            // Display the list of transactions
            else {
                List(viewModel.allTransactions, id: \.label) { transaction in
                    HStack {
                        // Show different icons and colors for income/expense
                        Image(systemName: transaction.value > 0 ? "arrow.up.right.circle.fill" : "arrow.down.left.circle.fill")
                            .foregroundColor(transaction.value > 0 ? .green : .red)
                        Text(transaction.label)
                        Spacer()
                        Text(transaction.value.formatted(.currency(code: "EUR")))
                            .fontWeight(.bold)
                            .foregroundColor(transaction.value > 0 ? .green : .red)
                    }
                }
            }
            Spacer()
        }
        .navigationTitle("All Transactions")
    }
}

#Preview {
    return NavigationView {
        AllTransactionsView(viewModel: AllTransactionsViewModel(authToken: "preview-token"))
    }
}
