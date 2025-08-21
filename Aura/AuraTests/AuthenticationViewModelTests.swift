//
//  AuthenticationViewModelTests.swift
//  AuraTests
//
//  Created by Test on 17/08/25.
//

import XCTest
@testable import Aura

class AuthenticationViewModelTests: XCTestCase {
    var viewModel: AuthenticationViewModel!
    var mockAPIService: MockAPIService!
    var loginSucceeded: Bool = false
    
    override func setUp() {
        super.setUp()
        mockAPIService = MockAPIService()
        loginSucceeded = false
        viewModel = AuthenticationViewModel { [weak self] in
            self?.loginSucceeded = true
        }
    }
    
    override func tearDown() {
        mockAPIService.reset()
        mockAPIService = nil
        viewModel = nil
        super.tearDown()
    }
    
    // MARK: - Basic Login Tests
    
    func testLoginWithValidCredentials() async {
        // Given: Valid credentials and successful server response
        mockAPIService.setupSuccessfulLogin(token: "test-token")
        viewModel.username = "test@aura.app"
        viewModel.password = "test123"
        
        // When: User logs in
        viewModel.login()
        
        // Wait a moment for the async operation to complete
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        // Then: Login should succeed
        XCTAssertTrue(loginSucceeded, "Login callback should be called")
        XCTAssertFalse(viewModel.showError, "Should not show error on success")
    }
    
    func testLoginWithInvalidEmail() {
        // Given: Invalid email format
        viewModel.username = "invalid-email"
        viewModel.password = "test123"
        
        // When: User tries to login
        viewModel.login()
        
        // Then: Should show email validation error
        XCTAssertTrue(viewModel.showError, "Should show error for invalid email")
        XCTAssertEqual(viewModel.errorMessage, "Email invalide", "Should show email error message")
        XCTAssertFalse(loginSucceeded, "Login should not succeed")
    }
    
    func testLoginWithNetworkError() async {
        // Given: Network error and valid credentials
        mockAPIService.setupNetworkError()
        viewModel.username = "test@aura.app"
        viewModel.password = "test123"
        
        // When: User tries to login
        viewModel.login()
        
        // Wait a moment for the async operation to complete
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        // Then: Should show login failure error
        XCTAssertTrue(viewModel.showError, "Should show error on network failure")
        XCTAssertEqual(viewModel.errorMessage, "Échec de connexion", "Should show login error message")
        XCTAssertFalse(loginSucceeded, "Login should not succeed")
    }
}
