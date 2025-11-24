//
//  LoginView.swift
//  FirebaseAuth
//
//  Created by Jade Rockwood on 11/23/25.
//


//
//  LoginView.swift
//  Notes App with Firebase Authentication
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var showSignUp = false
    @State private var showForgotPassword = false
    @State private var showSuccessAlert = false
    @State private var successMessage = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.purple.opacity(0.6)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Spacer()
                    
                    // App logo/title
                    VStack(spacing: 10) {
                        Image(systemName: "note.text")
                            .font(.system(size: 70))
                            .foregroundColor(.white)
                        
                        Text("Notes App")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("Sign in to continue")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.9))
                    }
                    .padding(.bottom, 40)
                    
                    // Login form
                    VStack(spacing: 16) {
                        // Email field
                        HStack {
                            Image(systemName: "envelope.fill")
                                .foregroundColor(.gray)
                            TextField("Email", text: $email)
                                .textInputAutocapitalization(.never)
                                .keyboardType(.emailAddress)
                                .autocorrectionDisabled()
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                        
                        // Password field
                        HStack {
                            Image(systemName: "lock.fill")
                                .foregroundColor(.gray)
                            SecureField("Password", text: $password)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                        
                        // Forgot password button
                        HStack {
                            Spacer()
                            Button(action: {
                                showForgotPassword = true
                            }) {
                                Text("Forgot Password?")
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                                    .underline()
                            }
                        }
                        .padding(.horizontal, 4)
                        
                        // Sign in button
                        Button(action: signIn) {
                            HStack {
                                if authViewModel.isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                } else {
                                    Text("Sign In")
                                        .fontWeight(.semibold)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
                        }
                        .disabled(authViewModel.isLoading || !isFormValid)
                        .opacity(isFormValid ? 1.0 : 0.6)
                        
                        // Divider
                        HStack {
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(.white.opacity(0.5))
                            Text("OR")
                                .font(.caption)
                                .foregroundColor(.white)
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(.white.opacity(0.5))
                        }
                        .padding(.vertical, 8)
                        
                        // Sign up button
                        Button(action: {
                            showSignUp = true
                        }) {
                            Text("Create New Account")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white)
                                .foregroundColor(.blue)
                                .cornerRadius(10)
                                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
                        }
                    }
                    .padding(.horizontal, 32)
                    
                    Spacer()
                }
            }
            .sheet(isPresented: $showSignUp) {
                SignUpView()
                    .environmentObject(authViewModel)
            }
            .sheet(isPresented: $showForgotPassword) {
                ForgotPasswordView()
                    .environmentObject(authViewModel)
            }
            .alert("Error", isPresented: $authViewModel.showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(authViewModel.errorMessage ?? "An unknown error occurred")
            }
            .alert("Success", isPresented: $showSuccessAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(successMessage)
            }
        }
    }
    
    // MARK: - Computed Properties
    private var isFormValid: Bool {
        !email.isEmpty && !password.isEmpty && authViewModel.isValidEmail(email)
    }
    
    // MARK: - Methods
    private func signIn() {
        authViewModel.signIn(email: email, password: password) { success in
            if success {
                // Navigation will happen automatically due to userSession change
                print("Login successful")
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(AuthViewModel())
    }
}