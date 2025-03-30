//
//  Models.swift
//  Aura
//
//  Created by Julien Choromanski on 29/03/2025.
//


import Foundation


// Structure to decode JSON response
struct AuthResponse: Decodable {
    let token: String
}


// Structure to encode JSON request body
struct AuthRequest: Encodable {
    let username: String
    let password: String
}


// Structure representing account details with balance and transaction history
struct AccountDetails: Decodable {
    let currentBalance: Decimal
    let transactions: [Transaction]
}


// Structure representing a single transaction with amount and description
struct Transaction: Decodable {
    let value: Decimal
    let label: String
}


// Structure for encoding the money transfer request body
struct TransferRequest: Encodable {
    let recipient: String
    let amount: Decimal
}
