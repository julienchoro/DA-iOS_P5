//
//  AllTransactionsViewModelTests.swift
//  AuraTests
//
//  Created by Julien Choromanski on 30/03/2025.
//


import XCTest
@testable import Aura


// This is a test class for the AllTransactionsViewModel
final class AllTransactionsViewModelTests: XCTestCase {
    var mockService: MockAllTransactionService!
    
    override func setUpWithError() throws {
        mockService = MockAllTransactionService()
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
    
    // Test case for successful fetch of all transactions
    @MainActor
    func testFetchAllTransactionsSuccess() async {
        let viewModel = AllTransactionsViewModel(authToken: "valid-token", service: mockService)
        
        while viewModel.isLoading {
            await Task.yield()
        }
        
        XCTAssertEqual(viewModel.allTransactions.count, 4)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    // Test case for fetch of all transactions with invalid token
    @MainActor
    func testFetchAllTransactionsWithInvalidToken() async {
        mockService.shouldSucceed = false
        mockService.mockError = AuthError.invalidToken
        
        let viewModel = AllTransactionsViewModel(authToken: "", service: mockService)
        
        while viewModel.isLoading {
            await Task.yield()
        }
        
        XCTAssertEqual(viewModel.errorMessage, "Authentication error. Please login again.")
        XCTAssertTrue(viewModel.allTransactions.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
    }
    
    // Test case for fetch of all transactions with network error
    @MainActor
    func testFetchAllTransactionsWithNetworkError() async {
        mockService.shouldSucceed = false
        mockService.mockError = URLError(.notConnectedToInternet)
        
        let viewModel = AllTransactionsViewModel(authToken: "valid-token", service: mockService)
        
        while viewModel.isLoading {
            await Task.yield()
        }
        
        XCTAssertEqual(viewModel.errorMessage, "Failed to load transaction history. Please try again.")
        XCTAssertTrue(viewModel.allTransactions.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
    }
    
    // Test case for loading indicator
    @MainActor
    func testLoadingIndicator() async {
        let viewModel = AllTransactionsViewModel(authToken: "valid-token", service: mockService)
        
        while viewModel.isLoading {
            await Task.yield()
        }
        
        XCTAssertFalse(viewModel.isLoading)
        
        viewModel.fetchAllTransactions()
        
        while viewModel.isLoading {
            await Task.yield()
        }
        
        XCTAssertFalse(viewModel.isLoading)
    }
}
