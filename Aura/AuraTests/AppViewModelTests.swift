//
//  AppViewModelTests.swift
//  AuraTests
//
//  Created by Test on 17/08/25.
//

import XCTest
@testable import Aura

class AppViewModelTests: XCTestCase {
    var viewModel: AppViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = AppViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    // MARK: - App State Tests
    
    func testInitialState() {
        XCTAssertFalse(viewModel.isLogged, "User should not be logged in initially")
    }
    
    func testLoginStateChange() {
        // Given: Initial logged out state
        XCTAssertFalse(viewModel.isLogged, "Should start logged out")
        
        // When: User logs in
        viewModel.isLogged = true
        
        // Then: Should be logged in
        XCTAssertTrue(viewModel.isLogged, "Should be able to set logged in state")
        
        // When: User logs out
        viewModel.isLogged = false
        
        // Then: Should be logged out
        XCTAssertFalse(viewModel.isLogged, "Should be able to set logged out state")
    }
    
    // MARK: - View Model Creation Tests
    
    func testAuthenticationViewModelCreation() {
        // When: Creating authentication view model
        let authViewModel = viewModel.authenticationViewModel
        
        // Then: Should create properly configured view model
        XCTAssertNotNil(authViewModel, "Should create authentication view model")
        XCTAssertEqual(authViewModel.username, "", "Username should be empty initially")
        XCTAssertEqual(authViewModel.password, "", "Password should be empty initially")
        XCTAssertFalse(authViewModel.showError, "Should not show error initially")
    }
    
    func testAccountDetailViewModelCreation() {
        // When: Creating account detail view model
        let accountViewModel = viewModel.accountDetailViewModel
        
        // Then: Should create properly configured view model
        XCTAssertNotNil(accountViewModel, "Should create account detail view model")
        XCTAssertEqual(accountViewModel.totalAmount, "€0.00", "Should have initial total amount")
        XCTAssertTrue(accountViewModel.recentTransactions.isEmpty, "Should have empty transactions initially")
    }
    
    func testLoginFlowIntegration() {
        // Given: Logged out state
        XCTAssertFalse(viewModel.isLogged, "Should start logged out")
        
        // When: User completes authentication
        let authViewModel = viewModel.authenticationViewModel
        authViewModel.onLoginSucceed()
        
        // Then: Should be logged in
        XCTAssertTrue(viewModel.isLogged, "Should be logged in after successful authentication")
    }
}