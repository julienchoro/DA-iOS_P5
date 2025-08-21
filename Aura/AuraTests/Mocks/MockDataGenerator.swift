//
//  MockDataGenerator.swift
//  AuraTests
//
//  Created by Test on 17/08/25.
//

import Foundation
@testable import Aura

// MARK: - Mock Data Generators

struct MockDataGenerator {
    
    static func createMockTransactions(count: Int) -> [Transaction] {
        var transactions: [Transaction] = []
        for i in 1...count {
            let isExpense = i % 3 != 0
            let value = Decimal(i * 10) * (isExpense ? -1 : 1)
            let label = isExpense ? "Expense \(i)" : "Income \(i)"
            transactions.append(Transaction(value: value, label: label))
        }
        return transactions
    }
    
    static func createMockAccountResponse(balance: Decimal = 5000, transactionCount: Int = 10) -> AccountResponse {
        return AccountResponse(
            currentBalance: balance,
            transactions: createMockTransactions(count: transactionCount)
        )
    }
    
    static func createAuthenticationSuccessJSON(token: String = "test-token-123") -> Data {
        let json = """
        {
            "token": "\(token)"
        }
        """
        return json.data(using: .utf8)!
    }
    
    static func createAccountResponseJSON(balance: Decimal = 1000, includeTransactions: Bool = true) -> Data {
        var transactionsJSON = ""
        if includeTransactions {
            transactionsJSON = """
            ,
            "transactions": [
                {"value": -50.00, "label": "Restaurant"},
                {"value": -25.50, "label": "Cinema"},
                {"value": 1500.00, "label": "Salary"}
            ]
            """
        } else {
            transactionsJSON = ",\n\"transactions\": []"
        }
        
        let json = """
        {
            "currentBalance": \(balance)\(transactionsJSON)
        }
        """
        return json.data(using: .utf8)!
    }
}
