//
//  AccountService.swift
//  Aura
//
//  Created by Julien Choromanski on 30/03/2025.
//

import Foundation


// Protocol for Account Service
protocol AccountServiceProtocol {
    // Function to fetch account details with token
    func fetchAccountDetails(token: String) async throws -> AccountDetails
}


// Account Service conforming to AccountServiceProtocol
struct AccountService: AccountServiceProtocol {
    // Fetch account details with token
    func fetchAccountDetails(token: String) async throws -> AccountDetails {
        // Check if account URL is valid
        guard let accountURL = URL(string: "http://127.0.0.1:8080/account") else {
            throw URLError(.badURL)
        }

        // Create request with token
        var request = URLRequest(url: accountURL)
        request.setValue(token, forHTTPHeaderField: "token")
        request.httpMethod = "GET"

        // Fetch data and response
        let (data, response) = try await URLSession.shared.data(for: request)

        // Check if response is valid
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 401 {
                throw AuthError.invalidToken
            }
            throw URLError(.badServerResponse)
        }

        // Decode and return account details
        return try JSONDecoder().decode(AccountDetails.self, from: data)
    }
}
