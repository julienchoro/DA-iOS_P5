//
//  MockAuthenticationService.swift
//  AuraTests
//
//  Created by Julien Choromanski on 30/03/2025.
//


import Foundation
@testable import Aura


// This is a mock implementation of the AuthenticationServiceProtocol for testing purposes
struct MockAuthenticationService: AuthenticationServiceProtocol {
    var shouldSucceed: Bool = true
    
    // This method simulates the login process
    func login(username: String, password: String) async throws -> String {
        // Validate the email format
        guard ValidationUtils.isValidEmail(username) else {
            throw AuthError.invalidEmail
        }
        
        // Simulate network error
        if !shouldSucceed {
            throw AuthError.networkError
        }
        
        // Simulate invalid credentials
        if username != "test@aura.app" || password != "test123" {
            throw AuthError.invalidCredentials
        }
        
        // Return a mock token
        return "mock-token"
    }
}
