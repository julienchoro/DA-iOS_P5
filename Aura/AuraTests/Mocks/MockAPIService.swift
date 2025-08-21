//
//  MockAPIService.swift
//  AuraTests
//
//  Created by Test on 17/08/25.
//

import Foundation
@testable import Aura

// MARK: - Mock API Service
class MockAPIService {
    var mockURLSession: MockURLSession
    var apiService: APIService
    
    init() {
        self.mockURLSession = MockURLSession()
        self.apiService = APIService.shared
        self.reset()
    }
    
    // MARK: - Setup Methods
    
    func setupSuccessfulLogin(token: String = "test-token-123") {
        let mockResponse = AuthenticationResponse(token: token)
        mockURLSession.mockData = try! JSONEncoder().encode(mockResponse)
        mockURLSession.mockError = nil
    }
    
    func setupFailedLogin() {
        mockURLSession.mockError = NSError(
            domain: "HTTPError",
            code: 401,
            userInfo: [NSLocalizedDescriptionKey: "Invalid credentials"]
        )
    }
    
    func setupNetworkError() {
        mockURLSession.mockError = URLError(.networkConnectionLost)
    }
    
    // MARK: - Actions
    
    func performLogin(email: String = "test@aura.app", password: String = "test123") async throws {
        try await apiService.login(email: email, password: password)
    }
    
    func setAuthToken(_ token: String) {
        apiService.authToken = token
    }
    
    func clearAuthToken() {
        apiService.authToken = nil
    }
    
    // MARK: - Reset
    
    func reset() {
        clearAuthToken()
        mockURLSession.mockData = nil
        mockURLSession.mockResponse = nil
        mockURLSession.mockError = nil
        apiService.urlSession = mockURLSession
    }
}
