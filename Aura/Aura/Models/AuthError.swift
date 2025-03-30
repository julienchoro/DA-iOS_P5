//
//  AuthError.swift
//  Aura
//
//  Created by Julien Choromanski on 30/03/2025.
//


import Foundation


// Enum for different authentication errors
enum AuthError: Error {
    case invalidEmail
    case invalidCredentials
    case serverError
    case networkError
    case invalidToken
}
