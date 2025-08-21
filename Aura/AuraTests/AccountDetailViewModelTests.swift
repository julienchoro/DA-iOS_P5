//
//  AccountDetailViewModelTests.swift
//  AuraTests
//
//  Created by Test on 17/08/25.
//

import XCTest
@testable import Aura

class AccountDetailViewModelTests: XCTestCase {
    var viewModel: AccountDetailViewModel!
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
    
    // MARK: - Account Data Tests
    
    func testFetchAccountDataSuccess() async {
        // Given: Mock account data with transactions
        let mockTransactions = [
            Transaction(value: -25.50, label: "Coffee"),
            Transaction(value: 1500.00, label: "Salary")
        ]
        let accountResponse = AccountResponse(
            currentBalance: 2000.0,
            transactions: mockTransactions
        )
        mockAPIService.mockURLSession.mockData = try! JSONEncoder().encode(accountResponse)
        viewModel = AccountDetailViewModel(urlSession: mockAPIService.mockURLSession)
        
        // When: User loads account data
        viewModel.fetchAccountData()
        
        // Wait for async operation
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        // Then: Account data should be loaded
        XCTAssertEqual(viewModel.totalAmount, "2 000,00 €", "Should display formatted balance")
        XCTAssertEqual(viewModel.recentTransactions.count, 2, "Should load recent transactions")
        XCTAssertEqual(viewModel.recentTransactions[0].label, "Coffee", "Should load correct transaction details")
    }
    
    func testFetchAccountDataWithoutToken() {
        // Given: No authentication token
        mockAPIService.clearAuthToken()
        viewModel = AccountDetailViewModel(urlSession: mockAPIService.mockURLSession)
        
        // Then: Should show default values
        XCTAssertEqual(viewModel.totalAmount, "€0.00", "Should show default amount without token")
        XCTAssertTrue(viewModel.recentTransactions.isEmpty, "Should have no transactions without token")
    }
    
    func testFetchAccountDataNetworkError() async {
        // Given: Network error
        mockAPIService.setupNetworkError()
        viewModel = AccountDetailViewModel(urlSession: mockAPIService.mockURLSession)
        
        // When: User tries to load account data
        viewModel.fetchAccountData()
        
        // Wait for async operation
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        // Then: Should handle error gracefully
        XCTAssertEqual(viewModel.totalAmount, "€0.00", "Should show default on error")
        XCTAssertTrue(viewModel.recentTransactions.isEmpty, "Should have no transactions on error")
    }
}
