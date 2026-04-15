//
//  ForgotPasswordViewModel.swift
//  GT-Demo
//
//  Created by Saket Pandhare on 15/04/26.
//

import Foundation
import Observation

@MainActor
@Observable
final class ForgotPasswordViewModel {
    var email: String = ""

    var isLoading: Bool = false
    var errorMessage: String?
    var didSubmit: Bool = false
    var successMessage: String?

    private let endpoint = URL(string: "https://example.com/api/forgot-password")!
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    var isFormValid: Bool {
        isValidEmail(email)
    }

    func sendResetLink() async {
        errorMessage = nil

        guard isValidEmail(email) else {
            errorMessage = ForgotPasswordError.invalidEmail.errorDescription
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            let response = try await performRequest(
                ForgotPasswordRequest(email: email)
            )
            successMessage = response.message
            didSubmit = true
        } catch let error as ForgotPasswordError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func reset() {
        email = ""
        errorMessage = nil
        successMessage = nil
        didSubmit = false
    }

    private func performRequest(_ request: ForgotPasswordRequest) async throws -> ForgotPasswordResponse {
        var urlRequest = URLRequest(url: endpoint)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try JSONEncoder().encode(request)

        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await session.data(for: urlRequest)
        } catch {
            throw ForgotPasswordError.network(error.localizedDescription)
        }

        guard let http = response as? HTTPURLResponse else {
            throw ForgotPasswordError.network("Invalid response.")
        }

        switch http.statusCode {
        case 200...299:
            do {
                return try JSONDecoder().decode(ForgotPasswordResponse.self, from: data)
            } catch {
                throw ForgotPasswordError.decoding
            }
        case 404:
            throw ForgotPasswordError.emailNotFound
        default:
            throw ForgotPasswordError.server(http.statusCode)
        }
    }

    private func isValidEmail(_ value: String) -> Bool {
        let pattern = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return value.range(of: pattern, options: .regularExpression) != nil
    }
}
