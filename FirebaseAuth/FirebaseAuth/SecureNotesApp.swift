//
//  AppDelegate.swift
//  FirebaseAuth
//
//  Created by Jade Rockwood on 11/23/25.
//


//
//  SecureNotesApp.swift
//  FirebaseAuth
//

import SwiftUI
import FirebaseCore

// App Delegate for Firebase configuration
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Configure Firebase
        FirebaseApp.configure()
        print("✅ Firebase configured successfully")
        return true
    }
}

@main
struct SecureNotesApp: App {
    // Register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    // Create a single instance of AuthViewModel
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
        }
    }
}
