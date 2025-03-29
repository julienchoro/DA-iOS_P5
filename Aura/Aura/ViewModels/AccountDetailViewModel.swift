//
//  AccountDetailViewModel.swift
//  Aura
//
//  Created by Vincent Saluzzo on 29/09/2023.
//

import Foundation


struct AccountDetails: Decodable {
    let currentBalance: Decimal
    let transactions: [Transaction]
}

struct Transaction: Decodable {
    let value: Decimal
    let label: String
}

@MainActor
class AccountDetailViewModel: ObservableObject {

    @Published var totalAmount: String = ""
    @Published var recentTransactions: [Transaction] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let authToken: String

    init(authToken: String) {
        self.authToken = authToken
        fetchAccountDetails()
    }

    func fetchAccountDetails() {
        isLoading = true
        errorMessage = nil
        print("Fetching account details...")

        Task {
            do {
                guard let accountURL = URL(string: "http://127.0.0.1:8080/account") else {
                    errorMessage = "Invalid API endpoint configuration."
                    isLoading = false
                    return
                }

                var request = URLRequest(url: accountURL)
                request.setValue(authToken, forHTTPHeaderField: "token")
                request.httpMethod = "GET"

                let (data, response) = try await URLSession.shared.data(for: request)

                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    print("Error: Invalid response or status code from /account")
                    throw URLError(.badServerResponse)
                }

                let decodedAccountDetails = try JSONDecoder().decode(AccountDetails.self, from: data)

                self.totalAmount = decodedAccountDetails.currentBalance.formatted(.currency(code: "EUR"))
                print("Account balance fetched: \(decodedAccountDetails.currentBalance)")

                self.recentTransactions = Array(decodedAccountDetails.transactions.prefix(3))
                print("Recent transactions processed: \(self.recentTransactions.count) items")

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
