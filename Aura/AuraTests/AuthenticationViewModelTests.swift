//
//  AuthenticationViewModelTests.swift
//  AuraTests
//
//  Created by Julien Choromanski on 30/03/2025.
//


import XCTest
@testable import Aura


// This is a test class for the AuthenticationViewModel
final class AuthenticationViewModelTests: XCTestCase {
    var mockService: MockAuthenticationService!
    
    override func setUpWithError() throws {
        mockService = MockAuthenticationService()
        mockService.shouldSucceed = true
    }
    
    override func tearDownWithError() throws {
        mockService.shouldSucceed = true
        mockService = nil
    }
    
    // Test case for successful login
    func testLoginSuccess() async throws {
        var callbackCalled = false
        let callbackToken = "mock-token"
        
        let viewModel = AuthenticationViewModel({ token in
            callbackCalled = true
            XCTAssertEqual(token, callbackToken)
        }, service: mockService)
        
        viewModel.username = "test@aura.app"
        viewModel.password = "test123"
        
        await viewModel.login()
        
        XCTAssertTrue(callbackCalled, "Le callback de succès devrait être appelé")
        XCTAssertEqual(viewModel.token, callbackToken)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    // Test case for login with invalid email
    func testLoginWithInvalidEmail() async throws {
        var callbackCalled = false
        
        let viewModel = AuthenticationViewModel({ _ in
            callbackCalled = true
        }, service: mockService)
        
        viewModel.username = "invalid-email"
        viewModel.password = "anypassword"
        
        await viewModel.login()
        
        XCTAssertFalse(callbackCalled, "Le callback ne devrait pas être appelé en cas d'erreur")
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.errorMessage, "Please enter a valid email address.")
        XCTAssertNil(viewModel.token)
    }
    
    // Test case for login with invalid credentials
    func testLoginWithInvalidCredentials() async throws {
        var callbackCalled = false
        
        let viewModel = AuthenticationViewModel({ _ in
            callbackCalled = true
        }, service: mockService)
        
        viewModel.username = "valid@email.com"
        viewModel.password = "wrongpassword"
        
        await viewModel.login()
        
        XCTAssertFalse(callbackCalled, "Le callback ne devrait pas être appelé en cas d'erreur")
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.errorMessage, "Invalid email or password. Please try again.")
        XCTAssertNil(viewModel.token)
    }
    
    // Test case for login with network error
    func testLoginWithNetworkError() async throws {
        var callbackCalled = false
        mockService.shouldSucceed = false
        
        let viewModel = AuthenticationViewModel({ _ in
            callbackCalled = true
        }, service: mockService)
        
        viewModel.username = "test@aura.app"
        viewModel.password = "test123"
        
        await viewModel.login()
        
        XCTAssertFalse(callbackCalled, "Le callback ne devrait pas être appelé en cas d'erreur")
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.errorMessage, "Network error. Please check your connection.")
        XCTAssertNil(viewModel.token)
    }
    
    // Test case for loading indicator
    func testLoadingIndicator() async throws {
        let viewModel = AuthenticationViewModel({ _ in }, service: mockService)
        
        viewModel.username = "test@aura.app"
        viewModel.password = "test123"
        
        XCTAssertFalse(viewModel.isLoading)
        
        await viewModel.login()
        
        XCTAssertFalse(viewModel.isLoading)
    }
}
