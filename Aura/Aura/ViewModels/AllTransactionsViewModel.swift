//
//  AllTransactionsViewModel.swift
//  Aura
//
//  Created by Julien Choromanski on 29/03/2025.
//

import Foundation

@MainActor
class AllTransactionsViewModel: ObservableObject {
    // Published properties for UI updates
    @Published var allTransactions: [Transaction] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let authToken: String
    
    init(authToken: String) {
        self.authToken = authToken
        fetchAllTransactions()
    }
    
    // Fetches all transactions from the backend API
    func fetchAllTransactions() {
        isLoading = true
        errorMessage = nil
        print("Fetching all transactions...")
        
        Task {
            
            do {
                // Configure and validate API endpoint
                guard let accountURL = URL(string: "http://127.0.0.1:8080/account") else {
                    errorMessage = "Invalid API endpoint configuration."
                    print("Error: Invalid URL")
                    return
                }
                
                // Prepare authenticated request
                var request = URLRequest(url: accountURL)
                request.setValue(authToken, forHTTPHeaderField: "token")
                request.httpMethod = "GET"
                
                let (data, response) = try await URLSession.shared.data(for: request)
                
                // Validate HTTP response
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    print("Error: Invalid response or status code from /account. Status: \((response as? HTTPURLResponse)?.statusCode ?? -1)")
                    throw URLError(.badServerResponse)
                }
                
                // Decode response and update transactions
                let decodedAccountDetails = try JSONDecoder().decode(AccountDetails.self, from: data)
                self.allTransactions = decodedAccountDetails.transactions
                print("All transactions fetched successfully: \(self.allTransactions.count) items")
                
            } catch {
                errorMessage = "Failed to load transaction history. Please try again."
                print("Error fetching all transactions: \(error)")
                
                if let decodingError = error as? DecodingError {
                    print("Decoding error details: \(decodingError)")
                }
            }

            isLoading = false
            print("Fetching complete.")
        }
    }
}
