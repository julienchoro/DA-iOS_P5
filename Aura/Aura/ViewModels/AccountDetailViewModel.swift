//
//  AccountDetailViewModel.swift
//  Aura
//
//  Created by Vincent Saluzzo on 29/09/2023.
//


import Foundation


@MainActor
class AccountDetailViewModel: ObservableObject {

    // Published properties for UI updates
    @Published var totalAmount: String = ""
    @Published var recentTransactions: [Transaction] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    // Properties for authentication and service
    let authToken: String
    private let accountService: AccountServiceProtocol
    
    // Initializer
    init(authToken: String, service: AccountServiceProtocol = AccountService()) {
        self.authToken = authToken
        self.accountService = service
        fetchAccountDetails()
    }

    // Function to fetch account details
    func fetchAccountDetails() {
        isLoading = true
        errorMessage = nil
        print("Fetching account details...")

        Task {
            do {
                let accountDetails = try await accountService.fetchAccountDetails(token: authToken)
                
                self.totalAmount = accountDetails.currentBalance.formatted(.currency(code: "EUR"))
                print("Account balance fetched: \(accountDetails.currentBalance)")

                self.recentTransactions = Array(accountDetails.transactions.prefix(3))
                print("Recent transactions processed: \(self.recentTransactions.count) items")

            } catch let error as AuthError where error == .invalidToken {
                errorMessage = "Authentication error. Please login again."
                print("Authentication error: Invalid token")
            } catch {
                errorMessage = "Failed to load account data. Please try again."
                print("Error fetching account details: \(error)")

                if let decodingError = error as? DecodingError {
                    print("Decoding error details: \(decodingError)")
                }
            }
            
            isLoading = false
            print("Fetching complete.")
        }
    }
}
