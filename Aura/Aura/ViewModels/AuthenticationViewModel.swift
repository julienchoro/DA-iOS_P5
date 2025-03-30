//
//  AuthenticationViewModel.swift
//  Aura
//
//  Created by Vincent Saluzzo on 29/09/2023.
//


import Foundation


// ViewModel for handling user authentication
class AuthenticationViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    @Published var token: String?
    
    let onLoginSucceed: ((_ token: String) -> ())
    
    private let authService: AuthenticationServiceProtocol
    
    // Initializer for the ViewModel
    init(_ callback: @escaping (String) -> (), service: AuthenticationServiceProtocol = AuthenticationService()) {
        self.onLoginSucceed = callback
        self.authService = service
    }
    
    // Function to handle user login
    @MainActor
    func login() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let token = try await authService.login(username: username, password: password)
            self.token = token
            self.isLoading = false
            self.onLoginSucceed(token)
        } catch let error as AuthError {
            isLoading = false
            switch error {
            case .invalidEmail:
                errorMessage = "Please enter a valid email address."
            case .invalidCredentials:
                errorMessage = "Invalid email or password. Please try again."
            case .serverError:
                errorMessage = "Server error. Please try again later."
            case .networkError:
                errorMessage = "Network error. Please check your connection."
            case .invalidToken:
                errorMessage = "Authentication error. Please login again."
            }
        } catch {
            errorMessage = "Login failed. Please check your credentials or connection."
            isLoading = false
        }
    }
}
