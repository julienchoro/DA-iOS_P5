//
//  MoneyTransferViewModel.swift
//  Aura
//
//  Created by Vincent Saluzzo on 29/09/2023.
//

import Foundation

// View model for money transfer functionality
@MainActor
class MoneyTransferViewModel: ObservableObject {
    @Published var recipient: String = ""
    @Published var amount: String = ""
    @Published var transferMessage: String = ""
    @Published var isLoading: Bool = false
    private let authToken: String

    init(authToken: String) {
        self.authToken = authToken
    }

    // Function to validate the recipient
    private func isValidRecipient(_ recipient: String) -> Bool {
        return ValidationUtils.isValidEmail(recipient) || ValidationUtils.isValidFrenchPhoneNumber(recipient)
    }

    // Function to send money
    func sendMoney() {
        transferMessage = ""
        isLoading = true

        guard isValidRecipient(recipient) else {
            transferMessage = "Please enter a valid email address or French phone number."
            isLoading = false
            return
        }

        guard let decimalAmount = ValidationUtils.validateAndConvertAmountString(self.amount) else {
            transferMessage = "Please enter a valid and positive amount."
            isLoading = false
            return
        }

        Task {
            do {
                guard let url = URL(string: "http://127.0.0.1:8080/account/transfer") else {
                    throw URLError(.badURL, userInfo: [NSLocalizedDescriptionKey: "Invalid API endpoint configuration."])
                }

                let transferRequest = TransferRequest(recipient: recipient, amount: decimalAmount)
                let requestBody = try JSONEncoder().encode(transferRequest)

                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.setValue(authToken, forHTTPHeaderField: "token")
                request.httpBody = requestBody

                let (_, response) = try await URLSession.shared.data(for: request)

                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
                    print("Error: Invalid response or status code from /account/transfer. Status: \(statusCode)")
                    throw URLError(.badServerResponse, userInfo: [NSLocalizedDescriptionKey: "Transfer failed. \(statusCode == 400 ? "Please check the provided data." : "Server error.") (Code: \(statusCode))"])
                }

                self.transferMessage = "Successfully transferred \(decimalAmount.formatted(.currency(code: "EUR"))) to \(recipient)!"

            } catch let error as URLError {
                 print("URL Error: \(error.localizedDescription)")
                 self.transferMessage = "Network or server error: \(error.localizedDescription)"
            } catch {
                 print("Transfer Error: \(error)")
                 self.transferMessage = "Transfer error: \(error.localizedDescription)"
            }

            isLoading = false
        }
    }
}
