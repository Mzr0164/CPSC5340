//
//  AuthenticationViews.swift
//  Hidden Library
//
//  Created by Meghan Rockwood
//
import SwiftUI

struct AuthenticationView: View {
    @State private var isSignUp = false
    
    var body: some View {
        if isSignUp {
            SignUpView(isSignUp: $isSignUp)
        } else {
            SignInView(isSignUp: $isSignUp)
        }
    }
}

struct SignInView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @Binding var isSignUp: Bool
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Hidden Library")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Retain your reading knowledge")
                .foregroundColor(.secondary)
            
            Spacer()
            
            VStack(spacing: 15) {
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                if !authViewModel.errorMessage.isEmpty {
                    Text(authViewModel.errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                
                Button(action: {
                    authViewModel.signIn(email: email, password: password)
                }) {
                    Text("Sign In")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Button(action: { isSignUp = true }) {
                    Text("Don't have an account? Sign Up")
                        .foregroundColor(.blue)
                }
            }
            .padding()
            
            Spacer()
        }
        .padding()
    }
}

struct SignUpView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @Binding var isSignUp: Bool
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Create Account")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Spacer()
            
            VStack(spacing: 15) {
                TextField("Username", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                SecureField("Confirm Password", text: $confirmPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                if !authViewModel.errorMessage.isEmpty {
                    Text(authViewModel.errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                
                Button(action: {
                    if password == confirmPassword {
                        authViewModel.signUp(email: email, password: password, username: username)
                    } else {
                        authViewModel.errorMessage = "Passwords don't match"
                    }
                }) {
                    Text("Sign Up")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Button(action: { isSignUp = false }) {
                    Text("Already have an account? Sign In")
                        .foregroundColor(.blue)
                }
            }
            .padding()
            
            Spacer()
        }
        .padding()
    }
}
