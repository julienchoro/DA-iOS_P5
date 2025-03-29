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
    
    var authenticationViewModel: AuthenticationViewModel {
        return AuthenticationViewModel { [weak self] token in
            self?.isLogged = true
            self?.authToken = token
        }
    }
    
    var accountDetailViewModel: AccountDetailViewModel {
        guard let authToken = authToken else {
            fatalError("Attempting to access accountDetailViewModel when not logged in")
        }
        return AccountDetailViewModel(authToken: authToken)
    }
}
