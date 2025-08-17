//
//  Transaction.swift
//  Aura
//
//  Created by Julien Choro on 17/08/25.
//

import Foundation

struct Transaction: Codable, Identifiable {
    var id: String { "\(label)-\(value)" }
    let value: Decimal
    let label: String
}
