//
//  AuthViewModel.swift
//  FirebaseAuth
//

import Foundation
import FirebaseCore
import class FirebaseAuth.User
import class FirebaseAuth.Auth
import enum FirebaseAuth.AuthErrorCode

@MainActor
class AuthViewModel: ObservableObject {
    // Published properties to track authentication state
    @Published var userSession: FirebaseAuth.User?  // Use full module path
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showError = false
    
    init() {
        // Check if there's a current user session
        self.userSession = FirebaseAuth.Auth.auth().currentUser
        
        // Listen for authentication state changes
        FirebaseAuth.Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.userSession = user
        }
    }
    
    // MARK: - Sign Up with Email and Password
    func signUp(email: String, password: String, completion: @escaping (Bool) -> Void) {
        isLoading = true
        errorMessage = nil
        showError = false
        
        FirebaseAuth.Auth.self
    }
}
