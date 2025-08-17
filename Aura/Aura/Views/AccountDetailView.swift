//
//  AccountDetailView.swift
//  Aura
//
//  Created by Vincent Saluzzo on 29/09/2023.
//

import SwiftUI

struct AccountDetailView: View {
    @ObservedObject var viewModel: AccountDetailViewModel
    @State private var showingAllTransactions = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Large Header displaying total amount
            VStack(spacing: 10) {
                Text("Your Balance")
                    .font(.headline)
                Text(viewModel.totalAmount)
                    .font(.system(size: 60, weight: .bold))
                    .foregroundColor(Color(hex: "#94A684")) // Using the green color you provided
                Image(systemName: "eurosign.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 80)
                    .foregroundColor(Color(hex: "#94A684"))
            }
            .padding(.top)
            
            // Display recent transactions
            VStack(alignment: .leading, spacing: 10) {
                Text("Recent Transactions")
                    .font(.headline)
                    .padding([.horizontal])
                ForEach(viewModel.recentTransactions) { transaction in
                    HStack {
                        Image(systemName: transaction.value >= 0 ? "arrow.up.right.circle.fill" : "arrow.down.left.circle.fill")
                            .foregroundColor(transaction.value >= 0 ? .green : .red)
                        Text(transaction.label)
                        Spacer()
                        Text("€\(transaction.value)")
                            .fontWeight(.bold)
                            .foregroundColor(transaction.value >= 0 ? .green : .red)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .padding([.horizontal])
                }
            }
            
            // Button to show modal with all transactions
            Button(action: {
                showingAllTransactions = true
            }) {
                HStack {
                    Image(systemName: "list.bullet")
                    Text("See all transactions")
                }
                .padding()
                .background(Color(hex: "#94A684"))
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .padding([.horizontal, .bottom])
            .sheet(isPresented: $showingAllTransactions) {
                AllTransactionsView()
            }
            
            Spacer()
        }
        .onTapGesture {
                    self.endEditing(true)  // This will dismiss the keyboard when tapping outside
                }
    }
        
}

#Preview {
    AccountDetailView(viewModel: AccountDetailViewModel())
}
