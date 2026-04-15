//
//  ForgotPasswordModel.swift
//  GT-Demo
//
//  Created by Saket Pandhare on 15/04/26.
//

import Foundation

struct ForgotPasswordRequest: Encodable {
    let email: String
}

struct ForgotPasswordResponse: Decodable {
    let message: String
}

enum ForgotPasswordError: LocalizedError {
    case invalidEmail
    case emailNotFound
    case network(String)
    case decoding
    case server(Int)

    var errorDescription: String? {
        switch self {
        case .invalidEmail: return "Please enter a valid email address."
        case .emailNotFound: return "We couldn't find an account with that email."
        case .network(let message): return message
        case .decoding: return "Unexpected response from server."
        case .server(let code): return "Server error (\(code)). Please try again."
        }
    }
}
