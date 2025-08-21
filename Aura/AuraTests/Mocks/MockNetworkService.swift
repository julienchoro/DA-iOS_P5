//
//  MockNetworkService.swift
//  AuraTests
//
//  Created by Test on 17/08/25.
//

import Foundation
@testable import Aura

// MARK: - Mock Network Service

class MockNetworkService {
    var shouldSucceed = true
    var mockToken: String = "mock-token-abc123"
    
    func simulateLogin(email: String, password: String) throws -> String {
        if shouldSucceed && email == "test@aura.app" && password == "test123" {
            return mockToken
        } else {
            throw URLError(.userAuthenticationRequired)
        }
    }
    
    func simulateAccountFetch(token: String) throws -> AccountResponse {
        if shouldSucceed && !token.isEmpty {
            return MockDataGenerator.createMockAccountResponse()
        } else {
            throw URLError(.badServerResponse)
        }
    }
    
    func simulateTransfer(token: String, recipient: String, amount: Decimal) throws -> Bool {
        if shouldSucceed && !token.isEmpty && Self.isValidAmount("\(amount)") {
            return true
        } else {
            throw URLError(.badServerResponse)
        }
    }
    
    private static func isValidAmount(_ amountString: String) -> Bool {
        if amountString.contains(",") { return false }
        guard let amount = Decimal(string: amountString) else { return false }
        return amount > 0
    }
}
