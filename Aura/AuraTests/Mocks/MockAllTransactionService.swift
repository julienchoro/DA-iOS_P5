//
//  MockAllTransactionService.swift
//  AuraTests
//
//  Created by Julien Choromanski on 30/03/2025.
//


import Foundation
@testable import Aura


// This is a mock implementation of the TransactionServiceProtocol for testing purposes
struct MockAllTransactionService: AllTransactionServiceProtocol {
    var shouldSucceed: Bool = true
    var mockAccountDetails: AccountDetails?
    var mockError: Error?
    
    // This method fetches all transactions for a given token
    func fetchAllTransactions(token: String) async throws -> AccountDetails {
        if !shouldSucceed {
            throw mockError ?? URLError(.badServerResponse)
        }
        
        if token.isEmpty {
            throw AuthError.invalidToken
        }
        
        return mockAccountDetails ?? AccountDetails(
            currentBalance: 1500.75,
            transactions: [
                Transaction(value: 250.0, label: "Dépôt"),
                Transaction(value: -75.0, label: "Achat"),
                Transaction(value: -120.0, label: "Transfert"),
                Transaction(value: 500.0, label: "Salaire")
            ]
        )
    }
}
