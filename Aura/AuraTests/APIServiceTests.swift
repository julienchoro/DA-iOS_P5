//
//  APIServiceTests.swift
//  AuraTests
//
//  Created by Test on 17/08/25.
//

import XCTest
@testable import Aura

class APIServiceTests: XCTestCase {
    var mockAPIService: MockAPIService!
    
    override func setUp() {
        super.setUp()
        mockAPIService = MockAPIService()
    }
    
    override func tearDown() {
        mockAPIService.reset()
        mockAPIService = nil
        super.tearDown()
    }
    
    // MARK: - Basic Login Tests
    
    func testLoginWithValidCredentials() async {
        // Given: Valid credentials and successful server response
        mockAPIService.setupSuccessfulLogin(token: "test-token-123")
        
        // When: User tries to login
        do {
            try await mockAPIService.performLogin(email: "test@aura.app", password: "test123")
            
            // Then: Token should be saved
            XCTAssertEqual(mockAPIService.apiService.authToken, "test-token-123")
        } catch {
            XCTFail("Login should succeed with valid credentials: \(error)")
        }
    }
    
    func testLoginWithInvalidCredentials() async {
        // Given: Server returns error for invalid credentials
        mockAPIService.setupFailedLogin()
        
        // When: User tries to login with wrong credentials
        do {
            try await mockAPIService.performLogin(email: "wrong@email.com", password: "wrong")
            XCTFail("Login should fail with invalid credentials")
        } catch {
            // Then: No token should be saved
            XCTAssertNil(mockAPIService.apiService.authToken)
        }
    }
    
    func testLoginWithNetworkError() async {
        // Given: Network is not available
        mockAPIService.setupNetworkError()
        
        // When: User tries to login
        do {
            try await mockAPIService.performLogin(email: "test@aura.app", password: "test123")
            XCTFail("Login should fail with network error")
        } catch {
            // Then: No token should be saved
            XCTAssertNil(mockAPIService.apiService.authToken)
        }
    }
    
    // MARK: - Token Management Tests
    
    func testTokenStorage() {
        // Given: No token initially
        XCTAssertNil(mockAPIService.apiService.authToken)
        
        // When: Token is set
        mockAPIService.setAuthToken("my-token")
        
        // Then: Token should be stored
        XCTAssertEqual(mockAPIService.apiService.authToken, "my-token")
        
        // When: Token is cleared
        mockAPIService.clearAuthToken()
        
        // Then: Token should be nil
        XCTAssertNil(mockAPIService.apiService.authToken)
    }
}

