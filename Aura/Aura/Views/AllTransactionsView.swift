//
//  AllTransactionsView.swift
//  Aura
//
//  Created by Julien Choro on 17/08/25.
//

import SwiftUI

struct AllTransactionsView: View {
    @StateObject private var viewModel = AllTransactionsViewModel()
    
    var body: some View {
        List(viewModel.transactions) { transaction in
            HStack {
                VStack(alignment: .leading) {
                    Text(transaction.label)
                        .font(.headline)
                }
                Spacer()
                Text("€\(transaction.value)")
                    .foregroundColor(transaction.value > 0 ? .green : .red)
                    .fontWeight(.bold)
            }
            .padding(.vertical, 4)
        }
        .navigationTitle("All Transactions")
    }
}

#Preview {
    AllTransactionsView()
}
