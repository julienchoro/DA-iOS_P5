//
//  TransferRequest.swift
//  Aura
//
//  Created by Julien Choro on 17/08/25.
//

import Foundation

struct TransferRequest: Codable {
    let recipient: String
    let amount: Decimal
}
