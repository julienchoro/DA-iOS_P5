//
//  AccountResponse.swift
//  Aura
//
//  Created by Julien Choro on 17/08/25.
//

import Foundation

struct AccountResponse: Codable {
    let currentBalance: Decimal
    let transactions: [Transaction]
}
