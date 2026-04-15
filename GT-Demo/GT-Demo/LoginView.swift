//
//  LoginView.swift
//  GT-Demo
//
//  Created by Saket Pandhare on 15/04/26.
//

import SwiftUI

struct LoginView: View {
    @State private var viewModel = LoginViewModel()
    @FocusState private var focusedField: Field?

    private enum Field {
        case email, password
    }

    var body: some View {
        ZStack {
            backgroundGradient
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 32) {
                    header
                        .padding(.top, 60)

                    card
                        .padding(.horizontal, 24)

                    if let message = viewModel.errorMessage {
                        Text(message)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .fill(Color.red.opacity(0.85))
                            )
                            .padding(.horizontal, 24)
                            .transition(.opacity.combined(with: .move(edge: .top)))
                    }

                    Spacer(minLength: 20)
                }
            }
            .scrollDismissesKeyboard(.interactively)
        }
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
                    .background(
                        Circle()
                            .stroke(.white.opacity(0.25), lineWidth: 1)
                    )

                Image(systemName: "lock.shield.fill")
                    .font(.system(size: 38, weight: .semibold))
                    .foregroundStyle(.white)
            }

            Text("Welcome Back")
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .foregroundStyle(.white)

            Text("Sign in to continue to your account")
                .font(.system(size: 15, weight: .regular))
                .foregroundStyle(.white.opacity(0.75))
        }
    }

    private var card: some View {
        VStack(spacing: 20) {
            emailField
            passwordField
            forgotPasswordButton
            loginButton
            divider
            socialButtons
            signUpPrompt
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
    }

    private var emailField: some View {
        FloatingField(
            systemImage: "envelope.fill",
            placeholder: "Email Address",
            text: $viewModel.email,
            isFocused: focusedField == .email
        ) {
            TextField("", text: $viewModel.email)
                .focused($focusedField, equals: .email)
                .keyboardType(.emailAddress)
                .textContentType(.emailAddress)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .submitLabel(.next)
                .onSubmit { focusedField = .password }
        }
    }

    private var passwordField: some View {
        FloatingField(
            systemImage: "lock.fill",
            placeholder: "Password",
            text: $viewModel.password,
            isFocused: focusedField == .password,
            trailing: {
                Button {
                    viewModel.isPasswordVisible.toggle()
                } label: {
                    Image(systemName: viewModel.isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                        .foregroundStyle(.white.opacity(0.7))
                }
            }
        ) {
            Group {
                if viewModel.isPasswordVisible {
                    TextField("", text: $viewModel.password)
                } else {
                    SecureField("", text: $viewModel.password)
                }
            }
            .focused($focusedField, equals: .password)
            .textContentType(.password)
            .submitLabel(.go)
            .onSubmit { Task { await login() } }
        }
    }

    private var forgotPasswordButton: some View {
        HStack {
            Spacer()
            Button {
                Task { await viewModel.forgotPassword() }
            } label: {
                Text("Forgot Password?")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.9))
            }
        }
    }

    private var loginButton: some View {
        Button {
            Task { await login() }
        } label: {
            ZStack {
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

                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(.white)
                } else {
                    Text("Login")
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                }
            }
            .frame(height: 54)
        }
        .disabled(viewModel.isLoading)
        .padding(.top, 4)
    }

    private var divider: some View {
        HStack(spacing: 12) {
            Rectangle()
                .fill(.white.opacity(0.25))
                .frame(height: 1)
            Text("OR")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(.white.opacity(0.7))
            Rectangle()
                .fill(.white.opacity(0.25))
                .frame(height: 1)
        }
    }

    private var socialButtons: some View {
        HStack(spacing: 14) {
            SocialButton(systemImage: "applelogo", action: {})
            SocialButton(systemImage: "g.circle.fill", action: {})
            SocialButton(systemImage: "f.circle.fill", action: {})
        }
    }

    private var signUpPrompt: some View {
        HStack(spacing: 4) {
            Text("Don't have an account?")
                .font(.system(size: 14))
                .foregroundStyle(.white.opacity(0.75))
            Button {
            } label: {
                Text("Sign Up")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(.white)
            }
        }
        .padding(.top, 4)
    }

    private func login() async {
        focusedField = nil
        await viewModel.login()
    }
}

private struct FloatingField<Field: View, Trailing: View>: View {
    let systemImage: String
    let placeholder: String
    @Binding var text: String
    let isFocused: Bool
    @ViewBuilder var field: () -> Field
    @ViewBuilder var trailing: () -> Trailing

    init(
        systemImage: String,
        placeholder: String,
        text: Binding<String>,
        isFocused: Bool,
        @ViewBuilder trailing: @escaping () -> Trailing = { EmptyView() },
        @ViewBuilder field: @escaping () -> Field
    ) {
        self.systemImage = systemImage
        self.placeholder = placeholder
        self._text = text
        self.isFocused = isFocused
        self.trailing = trailing
        self.field = field
    }

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: systemImage)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.white.opacity(0.8))
                .frame(width: 22)

            ZStack(alignment: .leading) {
                if text.isEmpty {
                    Text(placeholder)
                        .foregroundStyle(.white.opacity(0.55))
                        .font(.system(size: 15))
                }
                field()
                    .foregroundStyle(.white)
                    .tint(.white)
                    .font(.system(size: 15))
            }

            trailing()
        }
        .padding(.horizontal, 16)
        .frame(height: 54)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.white.opacity(isFocused ? 0.18 : 0.10))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(
                    isFocused ? .white.opacity(0.6) : .white.opacity(0.15),
                    lineWidth: 1
                )
        )
        .animation(.easeInOut(duration: 0.2), value: isFocused)
    }
}

private struct SocialButton: View {
    let systemImage: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(.white.opacity(0.12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .stroke(.white.opacity(0.2), lineWidth: 1)
                        )
                )
        }
    }
}

#Preview {
    LoginView()
}
