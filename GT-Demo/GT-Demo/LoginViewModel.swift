//
//  LoginViewModel.swift
//  GT-Demo
//
//  Created by Saket Pandhare on 15/04/26.
//

import Foundation
import Observation

@MainActor
@Observable
final class LoginViewModel {
    var email: String = ""
    var password: String = ""
    var isPasswordVisible: Bool = false

    var isLoading: Bool = false
    var errorMessage: String?
    var loggedInUser: User?

    private let endpoint = URL(string: "https://example.com/api/login")!
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    var isFormValid: Bool {
        isValidEmail(email) && !password.isEmpty
    }

    func login() async {
        errorMessage = nil

        guard isValidEmail(email) else {
            errorMessage = LoginError.invalidEmail.errorDescription
            return
        }
        guard !password.isEmpty else {
            errorMessage = LoginError.emptyPassword.errorDescription
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            let response = try await performLogin(
                LoginRequest(email: email, password: password)
            )
            loggedInUser = response.user
        } catch let error as LoginError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func forgotPassword() async {
    }

    private func performLogin(_ request: LoginRequest) async throws -> LoginResponse {
        var urlRequest = URLRequest(url: endpoint)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try JSONEncoder().encode(request)

        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await session.data(for: urlRequest)
        } catch {
            throw LoginError.network(error.localizedDescription)
        }

        guard let http = response as? HTTPURLResponse else {
            throw LoginError.network("Invalid response.")
        }

        switch http.statusCode {
        case 200...299:
            do {
                return try JSONDecoder().decode(LoginResponse.self, from: data)
            } catch {
                throw LoginError.decoding
            }
        case 401:
            throw LoginError.invalidCredentials
        default:
            throw LoginError.server(http.statusCode)
        }
    }

    private func isValidEmail(_ value: String) -> Bool {
        let pattern = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return value.range(of: pattern, options: .regularExpression) != nil
    }
}
