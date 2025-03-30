//
//  AuraApp.swift
//  Aura
//
//  Created by Vincent Saluzzo on 29/09/2023.
//


import SwiftUI


@main
struct AuraApp: App {
    @StateObject var viewModel = AppViewModel()
    
    var body: some Scene {
        WindowGroup {
            Group {
                // Check if the user is logged in
                if viewModel.isLogged {
                    // If logged in, show the tab view
                    TabView {
                        // Account detail view
                        NavigationView {
                            AccountDetailView(viewModel: viewModel.accountDetailViewModel)
                        }
                        .tabItem {
                            Image(systemName: "person.crop.circle")
                            Text("Account")
                        }
                        
                        // Money transfer view
                        MoneyTransferView(viewModel: viewModel.moneyTransferViewModel)
                            .tabItem {
                                Image(systemName: "arrow.right.arrow.left.circle")
                                Text("Transfer")
                            }
                    }
                    
                } else {
                    // If not logged in, show the authentication view
                    AuthenticationView(viewModel: viewModel.authenticationViewModel)
                        .transition(.asymmetric(insertion: .move(edge: .trailing).combined(with: .opacity),
                                                removal: .move(edge: .top).combined(with: .opacity)))
                    
                }
            }
            .accentColor(Color(hex: "#94A684"))
            .animation(.easeInOut(duration: 0.5), value: UUID())
        }
    }
}
