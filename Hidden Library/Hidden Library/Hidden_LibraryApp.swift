//
//  Hidden_LibraryApp.swift
//  Hidden Library
//
//  Created by Meghan Rockwood
//
import SwiftUI
import FirebaseCore

@main
struct HiddenLibraryApp: App {
    @StateObject private var authViewModel = AuthenticationViewModel()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
        }
    }
}
