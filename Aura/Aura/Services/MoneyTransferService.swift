//
//  MoneyTransferService.swift
//  Aura
//
//  Created by Julien Choromanski on 30/03/2025.
//

import Foundation


// Protocol for Money Transfer Service
protocol MoneyTransferServiceProtocol {
    // Function to transfer money to a recipient
    func transfer(recipient: String, amount: Decimal, token: String) async throws
}


// Structure conforming to MoneyTransferServiceProtocol
struct MoneyTransferService: MoneyTransferServiceProtocol {
    // Function to transfer money to a recipient
    func transfer(recipient: String, amount: Decimal, token: String) async throws {
        // Check if transfer URL is valid
        guard let url = URL(string: "http://127.0.0.1:8080/account/transfer") else {
            throw URLError(.badURL, userInfo: [NSLocalizedDescriptionKey: "Invalid API endpoint configuration."])
        }

        // Create transfer request
        let transferRequest = TransferRequest(recipient: recipient, amount: amount)
        let requestBody = try JSONEncoder().encode(transferRequest)

        // Create request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "token")
        request.httpBody = requestBody

        // Fetch data and response
        let (_, response) = try await URLSession.shared.data(for: request)

        // Check if response is valid
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
            print("Error: Invalid response or status code from /account/transfer. Status: \(statusCode)")
            
            // Handle different status codes
            if statusCode == 401 {
                throw AuthError.invalidToken
            }
            
            throw URLError(.badServerResponse, userInfo: [NSLocalizedDescriptionKey: "Transfer failed. \(statusCode == 400 ? "Please check the provided data." : "Server error.") (Code: \(statusCode))"])
        }
    }
}
