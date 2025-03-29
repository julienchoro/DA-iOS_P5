//
//  AppViewModel.swift
//  Aura
//
//  Created by Vincent Saluzzo on 29/09/2023.
//

import Foundation

@MainActor
class AppViewModel: ObservableObject {
    @Published var isLogged: Bool
    @Published var authToken: String?
    
    init() {
        isLogged = false
    }
    
    // View model that manages authentication state and user token
    var authenticationViewModel: AuthenticationViewModel {
        return AuthenticationViewModel { [weak self] token in
            self?.isLogged = true
            self?.authToken = token
        }
    }
    
    // View model that manages account details and balance
    var accountDetailViewModel: AccountDetailViewModel {
        guard let authToken = authToken else {
            fatalError("Attempting to access accountDetailViewModel when not logged in")
        }
        return AccountDetailViewModel(authToken: authToken)
    }

    // View model that manages money transfer functionality
    var moneyTransferViewModel: MoneyTransferViewModel {
        guard let authToken = authToken else {
            fatalError("Attempting to access moneyTransferViewModel when not logged in")
        }
        return MoneyTransferViewModel(authToken: authToken)
    }
    
}
