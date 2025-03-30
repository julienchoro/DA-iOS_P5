//
//  MockMoneyTransferService.swift
//  AuraTests
//
//  Created by Julien Choromanski on 30/03/2025.
//


import Foundation
@testable import Aura


// This is a mock implementation of the MoneyTransferServiceProtocol for testing purposes
class MockMoneyTransferService: MoneyTransferServiceProtocol {
    var shouldSucceed: Bool = true
    var mockError: Error?
    var lastTransferRequest: TransferRequest?
    
    // This method simulates the money transfer process
    func transfer(recipient: String, amount: Decimal, token: String) async throws {
        lastTransferRequest = TransferRequest(recipient: recipient, amount: amount)
        
        if !shouldSucceed {
            throw mockError ?? URLError(.badServerResponse)
        }
        
        if token.isEmpty {
            throw AuthError.invalidToken
        }
    }
}
