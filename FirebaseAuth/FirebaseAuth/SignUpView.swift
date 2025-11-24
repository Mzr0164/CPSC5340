//
//  SignUpView.swift
//  SecureNotes
//
//  Created by Jade Rockwood on 11/23/25.
//


//
//  SignUpView.swift
//  FirebaseAuth
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showSuccessAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [Color.purple.opacity(0.6), Color.blue.opacity(0.6)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Header
                        VStack(spacing: 10) {
                            Image(systemName: "person.badge.plus")
                                .font(.system(size: 60))
                                .foregroundColor(.white)
                                .padding(.top, 40)
                            
                            Text("Create Account")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text("Sign up to get started")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.9))
                        }
                        .padding(.bottom, 20)
                        
                        // Sign up form
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
                                SecureField("Password (min 6 characters)", text: $password)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                            
                            // Confirm password field
                            HStack {
                                Image(systemName: "lock.fill")
                                    .foregroundColor(.gray)
                                SecureField("Confirm Password", text: $confirmPassword)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                            
                            // Password validation messages
                            if !password.isEmpty {
                                VStack(alignment: .leading, spacing: 4) {
                                    ValidationRow(
                                        text: "At least 6 characters",
                                        isValid: password.count >= 6
                                    )
                                    
                                    if !confirmPassword.isEmpty {
                                        ValidationRow(
                                            text: "Passwords match",
                                            isValid: password == confirmPassword
                                        )
                                    }
                                }
                                .padding(.horizontal, 4)
                            }
                            
                            // Sign up button
                            Button(action: signUp) {
                                HStack {
                                    if authViewModel.isLoading {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    } else {
                                        Text("Sign Up")
                                            .fontWeight(.semibold)
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.purple)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
                            }
                            .disabled(authViewModel.isLoading || !isFormValid)
                            .opacity(isFormValid ? 1.0 : 0.6)
                            .padding(.top, 10)
                            
                            // Already have account button
                            HStack {
                                Text("Already have an account?")
                                    .foregroundColor(.white)
                                Button(action: {
                                    dismiss()
                                }) {
                                    Text("Sign In")
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                        .underline()
                                }
                            }
                            .font(.subheadline)
                            .padding(.top, 8)
                        }
                        .padding(.horizontal, 32)
                        
                        Spacer(minLength: 40)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.white)
                    }
                }
            }
            .alert("Error", isPresented: $authViewModel.showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(authViewModel.errorMessage ?? "An unknown error occurred")
            }
            .alert("Success", isPresented: $showSuccessAlert) {
                Button("OK", role: .cancel) {
                    dismiss()
                }
            } message: {
                Text("Account created successfully! You can now sign in.")
            }
        }
    }
    
    // MARK: - Computed Properties
    private var isFormValid: Bool {
        authViewModel.isValidEmail(email) &&
        authViewModel.isValidPassword(password) &&
        password == confirmPassword
    }
    
    // MARK: - Methods
    private func signUp() {
        authViewModel.signUp(email: email, password: password) { success in
            if success {
                showSuccessAlert = true
            }
        }
    }
}

// MARK: - Validation Row Component
struct ValidationRow: View {
    let text: String
    let isValid: Bool
    
    var body: some View {
        HStack {
            Image(systemName: isValid ? "checkmark.circle.fill" : "xmark.circle.fill")
                .foregroundColor(isValid ? .green : .red)
            Text(text)
                .font(.caption)
                .foregroundColor(.white)
            Spacer()
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
            .environmentObject(AuthViewModel())
    }
}