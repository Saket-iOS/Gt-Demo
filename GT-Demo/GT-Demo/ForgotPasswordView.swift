//
//  ForgotPasswordView.swift
//  GT-Demo
//
//  Created by Saket Pandhare on 15/04/26.
//

///This is forgot Password View
import SwiftUI

struct ForgotPasswordView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var email: String = ""
    @State private var didSubmit: Bool = false
    @FocusState private var isEmailFocused: Bool

    var body: some View {
        ZStack {
            backgroundGradient
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 32) {
                    header
                        .padding(.top, 40)

                    card
                        .padding(.horizontal, 24)

                    Spacer(minLength: 20)
                }
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.white)
                        .padding(10)
                        .background(
                            Circle().fill(.white.opacity(0.15))
                        )
                }
            }
        }
        .toolbarBackground(.hidden, for: .navigationBar)
    }

    private var backgroundGradient: some View {
        LinearGradient(
            colors: [
                Color(red: 0.10, green: 0.12, blue: 0.30),
                Color(red: 0.25, green: 0.18, blue: 0.55),
                Color(red: 0.45, green: 0.25, blue: 0.65)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    private var header: some View {
        VStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(.white.opacity(0.15))
                    .frame(width: 88, height: 88)
                    .overlay(
                        Circle().stroke(.white.opacity(0.25), lineWidth: 1)
                    )

                Image(systemName: "key.fill")
                    .font(.system(size: 36, weight: .semibold))
                    .foregroundStyle(.white)
            }

            Text("Forgot Password?")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundStyle(.white)

            Text("Enter your email and we'll send you a link to reset your password.")
                .font(.system(size: 15))
                .foregroundStyle(.white.opacity(0.75))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
    }

    private var card: some View {
        VStack(spacing: 20) {
            if didSubmit {
                successContent
            } else {
                formContent
            }
        }
        .padding(28)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .stroke(.white.opacity(0.2), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.25), radius: 20, x: 0, y: 10)
        )
        .animation(.easeInOut(duration: 0.3), value: didSubmit)
    }

    private var formContent: some View {
        VStack(spacing: 20) {
            emailField
            sendButton
            backToLoginButton
        }
    }

    private var successContent: some View {
        VStack(spacing: 18) {
            ZStack {
                Circle()
                    .fill(Color.green.opacity(0.25))
                    .frame(width: 72, height: 72)
                Image(systemName: "checkmark")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundStyle(.white)
            }

            Text("Check your inbox")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(.white)

            Text("We've sent a password reset link to\n\(email)")
                .font(.system(size: 14))
                .foregroundStyle(.white.opacity(0.8))
                .multilineTextAlignment(.center)

            Button {
                dismiss()
            } label: {
                Text("Back to Login")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.55, green: 0.35, blue: 0.95),
                                        Color(red: 0.85, green: 0.40, blue: 0.75)
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                    )
            }
            .padding(.top, 6)
        }
    }

    private var emailField: some View {
        HStack(spacing: 12) {
            Image(systemName: "envelope.fill")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.white.opacity(0.8))
                .frame(width: 22)

            ZStack(alignment: .leading) {
                if email.isEmpty {
                    Text("Email Address")
                        .foregroundStyle(.white.opacity(0.55))
                        .font(.system(size: 15))
                }
                TextField("", text: $email)
                    .focused($isEmailFocused)
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .submitLabel(.send)
                    .onSubmit(submit)
                    .foregroundStyle(.white)
                    .tint(.white)
                    .font(.system(size: 15))
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 54)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.white.opacity(isEmailFocused ? 0.18 : 0.10))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(
                    isEmailFocused ? .white.opacity(0.6) : .white.opacity(0.15),
                    lineWidth: 1
                )
        )
        .animation(.easeInOut(duration: 0.2), value: isEmailFocused)
    }

    private var sendButton: some View {
        Button(action: submit) {
            Text("Send Reset Link")
                .font(.system(size: 17, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.55, green: 0.35, blue: 0.95),
                                    Color(red: 0.85, green: 0.40, blue: 0.75)
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .shadow(color: Color(red: 0.55, green: 0.35, blue: 0.95).opacity(0.5),
                                radius: 12, x: 0, y: 6)
                )
        }
        .padding(.top, 4)
    }

    private var backToLoginButton: some View {
        Button {
            dismiss()
        } label: {
            HStack(spacing: 6) {
                Image(systemName: "arrow.left")
                    .font(.system(size: 13, weight: .bold))
                Text("Back to Login")
                    .font(.system(size: 14, weight: .semibold))
            }
            .foregroundStyle(.white.opacity(0.9))
        }
    }

    private func submit() {
        isEmailFocused = false
        didSubmit = true
    }
}

#Preview {
    NavigationStack {
        ForgotPasswordView()
    }
}
