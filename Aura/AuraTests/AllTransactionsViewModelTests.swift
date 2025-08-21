//
//  AllTransactionsViewModelTests.swift
//  AuraTests
//
//  Created by Test on 17/08/25.
//

import XCTest
@testable import Aura

class AllTransactionsViewModelTests: XCTestCase {
    var viewModel: AllTransactionsViewModel!
    var mockAPIService: MockAPIService!
    
    override func setUp() {
        super.setUp()
        mockAPIService = MockAPIService()
        mockAPIService.setAuthToken("test-token")
    }
    
    override func tearDown() {
        mockAPIService.reset()
        mockAPIService = nil
        viewModel = nil
        super.tearDown()
    }
    
    // MARK: - Transactions Tests
    
    func testFetchAllTransactionsSuccess() async {
        // Given: Valid token and mock transaction data
        let mockTransactions = [
            Transaction(value: -10.0, label: "Coffee"),
            Transaction(value: 1500.0, label: "Salary")
        ]
        let accountResponse = AccountResponse(
            currentBalance: 2000.0,
            transactions: mockTransactions
        )
        mockAPIService.mockURLSession.mockData = try! JSONEncoder().encode(accountResponse)
        viewModel = AllTransactionsViewModel(urlSession: mockAPIService.mockURLSession)
        
        // When: User loads all transactions
        viewModel.fetchAllTransactions()
        
        // Wait for async operation
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        // Then: All transactions should be loaded
        XCTAssertEqual(viewModel.transactions.count, 2, "Should load all transactions")
        XCTAssertEqual(viewModel.transactions[0].label, "Coffee", "Should load correct transaction details")
        XCTAssertEqual(viewModel.transactions[1].label, "Salary", "Should load correct transaction details")
    }
    
    func testFetchAllTransactionsWithoutToken() {
        // Given: No authentication token
        mockAPIService.clearAuthToken()
        viewModel = AllTransactionsViewModel(urlSession: mockAPIService.mockURLSession)
        
        // Then: Should not load transactions without token
        XCTAssertTrue(viewModel.transactions.isEmpty, "Should have no transactions without token")
    }
    
    func testFetchAllTransactionsNetworkError() async {
        // Given: Network error
        mockAPIService.setupNetworkError()
        viewModel = AllTransactionsViewModel(urlSession: mockAPIService.mockURLSession)
        
        // When: User tries to load transactions
        viewModel.fetchAllTransactions()
        
        // Wait for async operation
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        // Then: Should handle error gracefully
        XCTAssertTrue(viewModel.transactions.isEmpty, "Should have no transactions on error")
    }
}
