//
//  AccountDetailViewModel.swift
//  Aura
//
//  Created by Vincent Saluzzo on 29/09/2023.
//

import Foundation

class AccountDetailViewModel: ObservableObject {
    @Published var totalAmount = "€0.00"
    @Published var recentTransactions: [Transaction] = []
    
    init() {
        fetchAccountData()
    }
    
    func fetchAccountData() {
        Task {
            guard let token = APIService.shared.authToken else { return }
            
            let url = URL(string: "http://127.0.0.1:8080/account")!
            var request = URLRequest(url: url)
            request.setValue(token, forHTTPHeaderField: "token")
            
            do {
                let (data, _) = try await URLSession.shared.data(for: request)
                let response = try JSONDecoder().decode(AccountResponse.self, from: data)
                
                await MainActor.run {
                    totalAmount = "€\(response.currentBalance)"
                    recentTransactions = Array(response.transactions.prefix(3))
                }
            } catch {
                print("Error: \(error)")
            }
        }
    }
}
