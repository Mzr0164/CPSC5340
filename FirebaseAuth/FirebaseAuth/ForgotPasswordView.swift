//
//  ForgotPasswordView.swift
//  SecureNotes
//
//  Created by Jade Rockwood on 11/23/25.
//


//
//  ForgotPasswordView.swift
//  FirebaseAuth
//

import SwiftUI

struct ForgotPasswordView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var email = ""
    @State private var showSuccessAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [Color.orange.opacity(0.6), Color.red.opacity(0.6)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Spacer()
                    
                    // Header
                    VStack(spacing: 10) {
                        Image(systemName: "key.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.white)
                        
                        Text("Reset Password")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("Enter your email to receive reset instructions")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.9))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                    .padding(.bottom, 40)
                    
                    // Email input form
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
                        
                        // Send reset email button
                        Button(action: sendResetEmail) {
                            HStack {
                                if authViewModel.isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                } else {
                                    Text("Send Reset Email")
                                        .fontWeight(.semibold)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
                        }
                        .disabled(authViewModel.isLoading || !isFormValid)
                        .opacity(isFormValid ? 1.0 : 0.6)
                        
                        // Back to login button
                        Button(action: {
                            dismiss()
                        }) {
                            Text("Back to Sign In")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .underline()
                        }
                        .padding(.top, 8)
                    }
                    .padding(.horizontal, 32)
                    
                    Spacer()
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
            .alert("Email Sent", isPresented: $showSuccessAlert) {
                Button("OK", role: .cancel) {
                    dismiss()
                }
            } message: {
                Text("Password reset instructions have been sent to \(email). Please check your email.")
            }
        }
    }
    
    // MARK: - Computed Properties
    private var isFormValid: Bool {
        authViewModel.isValidEmail(email)
    }
    
    // MARK: - Methods
    private func sendResetEmail() {
        authViewModel.resetPassword(email: email) { success in
            if success {
                showSuccessAlert = true
            }
        }
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
            .environmentObject(AuthViewModel())
    }
}