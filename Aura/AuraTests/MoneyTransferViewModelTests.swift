//
//  MoneyTransferViewModelTests.swift
//  AuraTests
//
//  Created by Test on 17/08/25.
//

import XCTest
@testable import Aura

class MoneyTransferViewModelTests: XCTestCase {
    var viewModel: MoneyTransferViewModel!
    var mockAPIService: MockAPIService!
    
    override func setUp() {
        super.setUp()
        mockAPIService = MockAPIService()
        mockAPIService.setAuthToken("test-token")
        viewModel = MoneyTransferViewModel()
    }
    
    override func tearDown() {
        mockAPIService.reset()
        mockAPIService = nil
        viewModel = nil
        super.tearDown()
    }
    
    // MARK: - Input Validation Tests
    
    func testValidTransfer() {
        // Given: Valid recipient and amount
        viewModel.recipient = "test@example.com"
        viewModel.amount = "50.00"
        
        // When: User initiates transfer
        viewModel.sendMoney()
        
        // Then: Should show success (simplified - just checking validation passed)
        XCTAssertNotEqual(viewModel.transferMessage, "Email ou téléphone invalide")
        XCTAssertNotEqual(viewModel.transferMessage, "Montant invalide")
    }
    
    func testInvalidEmailRecipient() {
        // Given: Invalid email
        viewModel.recipient = "invalid-email"
        viewModel.amount = "50.00"
        
        // When: User tries to transfer
        viewModel.sendMoney()
        
        // Then: Should show validation error
        XCTAssertEqual(viewModel.transferMessage, "Email ou téléphone invalide")
    }
    
    func testInvalidAmount() {
        // Given: Valid recipient but invalid amount
        viewModel.recipient = "test@example.com"
        viewModel.amount = "0"
        
        // When: User tries to transfer
        viewModel.sendMoney()
        
        // Then: Should show amount error
        XCTAssertEqual(viewModel.transferMessage, "Montant invalide")
    }
    
    func testTransferWithoutToken() async {
        // Given: No authentication token
        mockAPIService.clearAuthToken()
        viewModel.recipient = "test@example.com"
        viewModel.amount = "50.00"
        
        // When: User tries to transfer
        viewModel.sendMoney()
        
        // Wait for async operation to complete
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        // Then: Should show authentication error
        XCTAssertEqual(viewModel.transferMessage, "Token d'authentification manquant")
    }
}
