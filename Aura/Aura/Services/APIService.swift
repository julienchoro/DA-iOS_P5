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
    
    private let tokenQueue = DispatchQueue(label: "com.aura.tokenQueue")
    private var _authToken: String?
    
    var authToken: String? {
        get { tokenQueue.sync { _authToken } }
        set { tokenQueue.async(flags: .barrier) { self._authToken = newValue } }
    }
    
    var urlSession: URLSessionProtocol = URLSession.shared
    
    func login(email: String, password: String) async throws {
        let url = URL(string: "\(baseURL)/auth")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = AuthenticationRequest(username: email, password: password)
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, _) = try await urlSession.data(for: request)
        let response = try JSONDecoder().decode(AuthenticationResponse.self, from: data)
        
        authToken = response.token
    }
}
