//
//  AllTransactionsViewModel.swift
//  Aura
//
//  Created by Julien Choro on 17/08/25.
//

import Foundation

class AllTransactionsViewModel: ObservableObject {
    @Published var transactions: [Transaction] = []
    
    init() {
        fetchAllTransactions()
    }
    
    func fetchAllTransactions() {
        Task {
            guard let token = APIService.shared.authToken else { return }
            
            let url = URL(string: "http://127.0.0.1:8080/account")!
            var request = URLRequest(url: url)
            request.setValue(token, forHTTPHeaderField: "token")
            
            do {
                let (data, _) = try await URLSession.shared.data(for: request)
                let response = try JSONDecoder().decode(AccountResponse.self, from: data)
                
                await MainActor.run {
                    transactions = response.transactions
                }
            } catch {
                print("Error: \(error)")
            }
        }
    }
}
