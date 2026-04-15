//
//  LoginModel.swift
//  GT-Demo
//
//  Created by Saket Pandhare on 15/04/26.
//
//This is Model Class 
import Foundation

struct LoginRequest: Encodable {
    let email: String
    let password: String
}

struct LoginResponse: Decodable {
    let token: String
    let user: User
}

struct User: Decodable, Identifiable {
    let id: Int
    let name: String
    let email: String
}

enum LoginError: LocalizedError {
    case invalidEmail
    case emptyPassword
    case invalidCredentials
    case network(String)
    case decoding
    case server(Int)

    var errorDescription: String? {
        switch self {
        case .invalidEmail: return "Please enter a valid email address."
        case .emptyPassword: return "Password cannot be empty."
        case .invalidCredentials: return "Incorrect email or password."
        case .network(let message): return message
        case .decoding: return "Unexpected response from server."
        case .server(let code): return "Server error (\(code)). Please try again."
        }
    }
}
