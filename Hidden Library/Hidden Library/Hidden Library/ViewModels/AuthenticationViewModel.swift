//
//  AuthenticationViewModel.swift
//  Hidden Library
//
//  Created by Meghan Rockwood
//
import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthenticationViewModel: ObservableObject {
    @Published var user: User?
    @Published var isAuthenticated = false
    @Published var errorMessage = ""
    
    private let db = Firestore.firestore()
    
    init() {
        checkAuthState()
    }
    
    func checkAuthState() {
        if let firebaseUser = Auth.auth().currentUser {
            fetchUserData(userId: firebaseUser.uid)
        }
    }
    
    func signUp(email: String, password: String, username: String) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
                return
            }
            
            guard let userId = result?.user.uid else { return }
            
            let newUser = User(
                id: userId,
                username: username,
                email: email,
                points: 0,
                createdAt: Date()
            )
            
            self?.saveUserToFirestore(user: newUser)
        }
    }
    
    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
                return
            }
            
            guard let userId = result?.user.uid else { return }
            self?.fetchUserData(userId: userId)
        }
    }
    
    func signOut() {
        try? Auth.auth().signOut()
        user = nil
        isAuthenticated = false
    }
    
    private func saveUserToFirestore(user: User) {
        do {
            try db.collection("users").document(user.id).setData(from: user)
            self.user = user
            self.isAuthenticated = true
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func fetchUserData(userId: String) {
        db.collection("users").document(userId).getDocument { [weak self] snapshot, error in
            if let data = snapshot?.data() {
                do {
                    let user = try Firestore.Decoder().decode(User.self, from: data)
                    self?.user = user
                    self?.isAuthenticated = true
                } catch {
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
