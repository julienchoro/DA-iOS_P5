//
//  AccountDetailViewModelTests.swift
//  AuraTests
//
//  Created by Julien Choromanski on 30/03/2025.
//


import XCTest
@testable import Aura


// This is a test class for the AccountDetailViewModel
final class AccountDetailViewModelTests: XCTestCase {
    var mockService: MockAccountService!
    
    override func setUpWithError() throws {
        mockService = MockAccountService()
        mockService.shouldSucceed = true
        
        let testTransactions = [
            Transaction(value: 250.0, label: "Dépôt"),
            Transaction(value: -75.0, label: "Achat"),
            Transaction(value: -120.0, label: "Transfert"),
            Transaction(value: 500.0, label: "Salaire")
        ]
        
        mockService.mockAccountDetails = AccountDetails(
            currentBalance: 1500.75,
            transactions: testTransactions
        )
    }
    
    override func tearDownWithError() throws {
        mockService.shouldSucceed = true
        mockService.mockAccountDetails = nil
        mockService.mockError = nil
        mockService = nil
    }
    
    // Test case for successful fetch of account details
    @MainActor
    func testFetchAccountDetailsSuccess() async {
        let viewModel = AccountDetailViewModel(authToken: "valid-token", service: mockService)
        
        while viewModel.isLoading {
            await Task.yield()
        }
        
        XCTAssertEqual(viewModel.totalAmount, "€1 500,75")
        
        XCTAssertEqual(viewModel.recentTransactions.count, 3)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    // Test case for fetch of account details with invalid token
    @MainActor
    func testFetchAccountDetailsWithInvalidToken() async {
        mockService.shouldSucceed = false
        mockService.mockError = AuthError.invalidToken
        
        let viewModel = AccountDetailViewModel(authToken: "", service: mockService)
        
        while viewModel.isLoading {
            await Task.yield()
        }
        
        XCTAssertEqual(viewModel.errorMessage, "Authentication error. Please login again.")
        XCTAssertTrue(viewModel.recentTransactions.isEmpty)
        XCTAssertEqual(viewModel.totalAmount, "")
        XCTAssertFalse(viewModel.isLoading)
    }
    
    // Test case for fetch of account details with network error
    @MainActor
    func testFetchAccountDetailsWithNetworkError() async {
        mockService.shouldSucceed = false
        mockService.mockError = URLError(.notConnectedToInternet)
        
        let viewModel = AccountDetailViewModel(authToken: "valid-token", service: mockService)
        
        while viewModel.isLoading {
            await Task.yield()
        }
        
        XCTAssertEqual(viewModel.errorMessage, "Failed to load account data. Please try again.")
        XCTAssertTrue(viewModel.recentTransactions.isEmpty)
        XCTAssertEqual(viewModel.totalAmount, "")
        XCTAssertFalse(viewModel.isLoading)
    }
    
    // Test case for loading indicator
    @MainActor
    func testLoadingIndicator() async {
        let viewModel = AccountDetailViewModel(authToken: "valid-token", service: mockService)
        
        while viewModel.isLoading {
            await Task.yield()
        }
        
        XCTAssertFalse(viewModel.isLoading)
        
        viewModel.fetchAccountDetails()
        
        while viewModel.isLoading {
            await Task.yield()
        }
        
        XCTAssertFalse(viewModel.isLoading)
    }
}
