//
//  AuthenticationService.swift
//  Aura
//
//  Created by Julien Choromanski on 30/03/2025.
//

import Foundation

// Protocol for Authentication Service
protocol AuthenticationServiceProtocol {
    // Function to login with username and password
    func login(username: String, password: String) async throws -> String
}


// Structure conforming to AuthenticationServiceProtocol
struct AuthenticationService: AuthenticationServiceProtocol {
    // Function to login with username and password
    func login(username: String, password: String) async throws -> String {
        // Validate email
        guard ValidationUtils.isValidEmail(username) else {
            throw AuthError.invalidEmail
        }
        
        // Check if URL is valid
        guard let url = URL(string: "http://127.0.0.1:8080/auth") else {
            throw AuthError.serverError
        }
        
        // Create request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Create request body
        let body = AuthRequest(username: username, password: password)
        
        // Encode request body
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            throw AuthError.serverError
        }
        
        // Fetch data and response
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // Check if response is valid
            guard let httpResponse = response as? HTTPURLResponse else {
                throw AuthError.networkError
            }
            
            // Handle different status codes
            if httpResponse.statusCode == 401 {
                throw AuthError.invalidCredentials
            } else if httpResponse.statusCode != 200 {
                throw AuthError.serverError
            }
            
            // Decode and return token
            do {
                let authResponse = try JSONDecoder().decode(AuthResponse.self, from: data)
                return authResponse.token
            } catch {
                throw AuthError.serverError
            }
        } catch let authError as AuthError {
            throw authError
        } catch {
            throw AuthError.networkError
        }
    }
}
