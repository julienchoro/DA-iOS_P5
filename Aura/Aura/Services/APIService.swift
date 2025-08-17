//
//  APIService.swift
//  Aura
//
//  Created by Julien Choro on 17/08/25.
//

import Foundation

class APIService {
    static let shared = APIService()
    private let baseURL = "http://127.0.0.1:8080"
    
    // Token en UserDefaults (suffisant pour un MVP)
    var authToken: String? {
        get { UserDefaults.standard.string(forKey: "authToken") }
        set { UserDefaults.standard.set(newValue, forKey: "authToken") }
    }
    
    func login(email: String, password: String) async throws -> Bool {
        let url = URL(string: "\(baseURL)/auth")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = AuthenticationRequest(username: email, password: password)
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(AuthenticationResponse.self, from: data)
        
        authToken = response.token
        return true
    }
}
