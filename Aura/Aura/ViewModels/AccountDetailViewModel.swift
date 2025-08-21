//
//  AccountDetailViewModelTests.swift
//  AuraTests
//
//  Created by Test on 17/08/25.
//
import Foundation

protocol URLSessionProtocol {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}

class AccountDetailViewModel: ObservableObject {
    @Published var totalAmount = "€0.00"
    @Published var recentTransactions: [Transaction] = []
    
    private let urlSession: URLSessionProtocol
    
    init(urlSession: URLSessionProtocol = URLSession.shared) {
        self.urlSession = urlSession
        if APIService.shared.authToken != nil {
            fetchAccountData()
        }
    }
    
    func fetchAccountData() {
        Task {
            guard let token = APIService.shared.authToken else { return }
            
            let url = URL(string: "http://127.0.0.1:8080/account")!
            var request = URLRequest(url: url)
            request.setValue(token, forHTTPHeaderField: "token")
            
            do {
                let (data, _) = try await urlSession.data(for: request)
                let response = try JSONDecoder().decode(AccountResponse.self, from: data)
                
                await MainActor.run {
                    totalAmount = formatAsCurrency(response.currentBalance)
                    recentTransactions = Array(response.transactions.prefix(3))
                }
            } catch {
                print("Error: \(error)")
            }
        }
    }
    
    private func formatAsCurrency(_ amount: Decimal) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "€"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.currencyGroupingSeparator = "\u{00a0}"
        formatter.currencyDecimalSeparator = ","
        return formatter.string(from: amount as NSDecimalNumber) ?? "€0.00"
    }
}
