//
//  AuthenticationViewModel.swift
//  Aura
//
//  Created by Vincent Saluzzo on 29/09/2023.
//

import Foundation

class AuthenticationViewModel: ObservableObject {
    @Published var username = ""
    @Published var password = ""
    @Published var showError = false
    @Published var errorMessage = ""
    
    let onLoginSucceed: () -> Void
    
    init(_ callback: @escaping () -> Void) {
        self.onLoginSucceed = callback
    }
    
    func login() {
        // Validation email basique
        guard isValidEmail(username) else {
            errorMessage = "Email invalide"
            showError = true
            return
        }
        
        Task {
            do {
                _ = try await APIService.shared.login(email: username, password: password)
                await MainActor.run {
                    onLoginSucceed()
                }
            } catch {
                await MainActor.run {
                    errorMessage = "Échec de connexion"
                    showError = true
                }
            }
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
}
