//
//  AuthenticationViewModel.swift
//  Aura
//
//  Created by Vincent Saluzzo on 29/09/2023.
//

import Foundation

// Structure pour décoder la réponse JSON
struct AuthResponse: Decodable {
    let token: String
}

// Structure pour encoder le corps de la requête JSON
struct AuthRequest: Encodable {
    let username: String
    let password: String
}

// ViewModel gérant l'authentification de l'utilisateur
class AuthenticationViewModel: ObservableObject {
    // Données de l'utilisateur
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    @Published var token: String?
    
    let onLoginSucceed: ((_ token: String) -> ())
    
    init(_ callback: @escaping (String) -> ()) {
        self.onLoginSucceed = callback
    }
    
    // Vérifie si l'email est dans un format valide
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }

    // Fonction principale de connexion
    func login() {
        
        guard isValidEmail(username) else {
            errorMessage = "Please enter a valid email address."
            isLoading = false
            return
        }

        isLoading = true
        errorMessage = nil

        let genericErrorMessage = "Login failed. Please check your credentials or connection."

        guard let url = URL(string: "http://127.0.0.1:8080/auth") else {
            self.errorMessage = "Internal configuration error."
            self.isLoading = false
            return
        }

        // Préparation de la requête HTTP
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = AuthRequest(username: username, password: password)
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            self.errorMessage = genericErrorMessage
            self.isLoading = false
            return
        }

        // Exécution de la requête d'authentification
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false

                guard let httpResponse = response as? HTTPURLResponse, error == nil else {
                    self.errorMessage = genericErrorMessage
                    return
                }

                guard (200...299).contains(httpResponse.statusCode) else {
                    self.errorMessage = genericErrorMessage
                    return
                }

                guard let data = data else {
                    self.errorMessage = genericErrorMessage
                    return
                }

                do {
                    let authResponse = try JSONDecoder().decode(AuthResponse.self, from: data)
                    print("Login successful! Token: \(authResponse.token)")
                    self.token = authResponse.token
                    self.onLoginSucceed(authResponse.token)
                } catch {
                    self.errorMessage = genericErrorMessage
                }
            }
        }.resume()
    }
}
