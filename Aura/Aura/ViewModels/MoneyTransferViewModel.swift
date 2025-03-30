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
    private let transferService: MoneyTransferServiceProtocol

    init(authToken: String, customService: MoneyTransferServiceProtocol? = nil) {
        self.authToken = authToken
        self.transferService = customService ?? MoneyTransferService()
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
                try await transferService.transfer(recipient: recipient, amount: decimalAmount, token: authToken)
                self.transferMessage = "Successfully transferred \(decimalAmount.formatted(.currency(code: "EUR"))) to \(recipient)!"
            } catch let error as URLError {
                print("URL Error: \(error.localizedDescription)")
                self.transferMessage = "Network or server error: \(error.localizedDescription)"
            } catch let error as AuthError where error == .invalidToken {
                print("Auth Error: \(error.localizedDescription)")
                self.transferMessage = "Authentication error. Please login again."
            } catch {
                print("Transfer Error: \(error)")
                self.transferMessage = "Transfer error: \(error.localizedDescription)"
            }

            isLoading = false
        }
    }
}
