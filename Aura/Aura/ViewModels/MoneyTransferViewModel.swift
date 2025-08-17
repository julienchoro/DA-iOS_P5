//
//  MoneyTransferViewModel.swift
//  Aura
//
//  Created by Vincent Saluzzo on 29/09/2023.
//

import Foundation

class MoneyTransferViewModel: ObservableObject {
    @Published var recipient = ""
    @Published var amount = ""
    @Published var transferMessage = ""
    
    func sendMoney() {
        // Validation
        guard isValidRecipient(recipient) else {
            transferMessage = "Email ou téléphone invalide"
            return
        }
        
        guard let amountDecimal = Decimal(string: amount), amountDecimal > 0 else {
            transferMessage = "Montant invalide"
            return
        }
        
        Task {
            guard let token = APIService.shared.authToken else { return }
            
            let url = URL(string: "http://127.0.0.1:8080/account/transfer")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue(token, forHTTPHeaderField: "token")
            
            let transfer = TransferRequest(recipient: recipient, amount: amountDecimal)
            request.httpBody = try? JSONEncoder().encode(transfer)
            
            do {
                let (_, response) = try await URLSession.shared.data(for: request)
                if let httpResponse = response as? HTTPURLResponse,
                   httpResponse.statusCode == 200 {
                    await MainActor.run {
                        transferMessage = "Transfert réussi!"
                        recipient = ""
                        amount = ""
                    }
                }
            } catch {
                await MainActor.run {
                    transferMessage = "Échec du transfert"
                }
            }
        }
    }
    
    private func isValidRecipient(_ recipient: String) -> Bool {
        // Email regex
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        // French phone regex
        let phoneRegex = "^(?:(?:\\+|00)33[\\s.-]{0,3}(?:\\(0\\)[\\s.-]{0,3})?|0)[1-9](?:[\\s.-]?\\d{2}){4}$"
        
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: recipient) ||
               NSPredicate(format: "SELF MATCHES %@", phoneRegex).evaluate(with: recipient)
    }
}
