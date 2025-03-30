//
//  AllTransactionsViewModel.swift
//  Aura
//
//  Created by Julien Choromanski on 29/03/2025.
//


import Foundation


@MainActor
class AllTransactionsViewModel: ObservableObject {
    @Published var allTransactions: [Transaction] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let authToken: String
    private let transactionService: AllTransactionServiceProtocol
    
    init(authToken: String, service: AllTransactionServiceProtocol = AllTransactionService()) {
        self.authToken = authToken
        self.transactionService = service
        fetchAllTransactions()
    }
    
    func fetchAllTransactions() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let accountDetails = try await transactionService.fetchAllTransactions(token: authToken)
                self.allTransactions = accountDetails.transactions
                
            } catch let error as AuthError where error == .invalidToken {
                errorMessage = "Authentication error. Please login again."
            } catch {
                errorMessage = "Failed to load transaction history. Please try again."
                
                if let decodingError = error as? DecodingError {
                    print("Decoding error details: \(decodingError)")
                }
            }

            isLoading = false
        }
    }
}
