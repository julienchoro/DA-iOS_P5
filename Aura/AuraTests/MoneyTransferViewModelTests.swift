//
//  MoneyTransferViewModelTests.swift
//  AuraTests
//
//  Created by Julien Choromanski on 30/03/2025.
//


import XCTest
@testable import Aura


// This is a test class for the MoneyTransferViewModel
final class MoneyTransferViewModelTests: XCTestCase {
    var mockService: MockMoneyTransferService!
    
    override func setUpWithError() throws {
        mockService = MockMoneyTransferService()
        mockService.shouldSucceed = true
        mockService.mockError = nil
    }
    
    override func tearDownWithError() throws {
        mockService.shouldSucceed = true
        mockService.mockError = nil
        mockService.lastTransferRequest = nil
        mockService = nil
    }
    
    // Test case for successful money transfer
    @MainActor
    func testSendMoneySuccess() async {
        let viewModel = MoneyTransferViewModel(authToken: "valid-token", customService: mockService)
        viewModel.recipient = "test@example.com"
        viewModel.amount = "100,50"
        
        viewModel.sendMoney()
        
        while viewModel.isLoading {
            await Task.yield()
        }
        
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertTrue(viewModel.transferMessage.contains("Successfully transferred"))
        XCTAssertTrue(viewModel.transferMessage.contains("test@example.com"))
        
        XCTAssertNotNil(mockService.lastTransferRequest)
        XCTAssertEqual(mockService.lastTransferRequest?.recipient, "test@example.com")
        XCTAssertEqual(mockService.lastTransferRequest?.amount, 100.5)
    }
    
    // Test case for money transfer with invalid recipient
    @MainActor
    func testSendMoneyInvalidRecipient() async {
        let viewModel = MoneyTransferViewModel(authToken: "valid-token", customService: mockService)
        viewModel.recipient = "invalid-email"
        viewModel.amount = "100"
        
        viewModel.sendMoney()
        
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.transferMessage, "Please enter a valid email address or French phone number.")
        
        XCTAssertNil(mockService.lastTransferRequest)
    }
    
    // Test case for money transfer with invalid amount
    @MainActor
    func testSendMoneyInvalidAmount() async {
        let viewModel = MoneyTransferViewModel(authToken: "valid-token", customService: mockService)
        viewModel.recipient = "test@example.com"
        viewModel.amount = "-100"
        
        viewModel.sendMoney()
        
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.transferMessage, "Please enter a valid and positive amount.")
        
        XCTAssertNil(mockService.lastTransferRequest)
    }
    
    // Test case for money transfer with authentication failure
    @MainActor
    func testSendMoneyAuthenticationFailure() async {
        mockService.shouldSucceed = false
        mockService.mockError = AuthError.invalidToken
        
        let viewModel = MoneyTransferViewModel(authToken: "", customService: mockService)
        viewModel.recipient = "test@example.com"
        viewModel.amount = "100"
        
        viewModel.sendMoney()
        
        while viewModel.isLoading {
            await Task.yield()
        }
        
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertTrue(viewModel.transferMessage.contains("Authentication error"))
        
        XCTAssertNotNil(mockService.lastTransferRequest)
    }
    
    // Test case for money transfer with network error
    @MainActor
    func testSendMoneyNetworkError() async {
        mockService.shouldSucceed = false
        mockService.mockError = URLError(.notConnectedToInternet)
        
        let viewModel = MoneyTransferViewModel(authToken: "valid-token", customService: mockService)
        viewModel.recipient = "test@example.com"
        viewModel.amount = "100"
        
        viewModel.sendMoney()
        
        while viewModel.isLoading {
            await Task.yield()
        }
        
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertTrue(viewModel.transferMessage.contains("Network or server error"))
        
        XCTAssertNotNil(mockService.lastTransferRequest)
    }
    
    // Test case for loading indicator
    @MainActor
    func testLoadingIndicator() async {
        let viewModel = MoneyTransferViewModel(authToken: "valid-token", customService: mockService)
        viewModel.recipient = "test@example.com"
        viewModel.amount = "100"
        
        viewModel.sendMoney()
        
        while viewModel.isLoading {
            await Task.yield()
        }
        
        XCTAssertFalse(viewModel.isLoading)
        
        XCTAssertNotNil(mockService.lastTransferRequest)
    }
    
    // Test case for money transfer with French phone number
    @MainActor
    func testSendMoneyWithFrenchPhoneNumber() async {
        let viewModel = MoneyTransferViewModel(authToken: "valid-token", customService: mockService)
        viewModel.recipient = "+33612345678"
        viewModel.amount = "100"
        
        viewModel.sendMoney()
        
        while viewModel.isLoading {
            await Task.yield()
        }
        
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertTrue(viewModel.transferMessage.contains("Successfully transferred"))
        
        XCTAssertNotNil(mockService.lastTransferRequest)
        XCTAssertEqual(mockService.lastTransferRequest?.recipient, "+33612345678")
    }
}
