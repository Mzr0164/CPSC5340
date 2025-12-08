//
//  Hidden_LibraryApp.swift
//  Hidden Library
//
//  Created by Meghan Rockwood
//
import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

@main
struct HiddenLibraryApp: App {
    @StateObject private var authViewModel = AuthenticationViewModel()
    
    init() {
        // Check if Firebase is configured
        print("🚀 App starting...")
        print("📱 Bundle ID: \(Bundle.main.bundleIdentifier ?? "NONE")")
        
        if FirebaseApp.app() == nil {
            print("⚙️ Configuring Firebase...")
            FirebaseApp.configure()
            print("✅ Firebase.configure() called")
        } else {
            print("✅ Firebase already configured")
        }
        
        // Detailed connection test
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            print("\n🔍 Testing Firebase connection...")
            print("   App Name: \(FirebaseApp.app()?.name ?? "NONE")")
            print("   Options: \(FirebaseApp.app()?.options.bundleID ?? "NONE")")
            
            let db = Firestore.firestore()
            print("   Firestore instance created")
            
            let testRef = db.collection("test").document("connection-test")
            print("   Attempting to write test document...")
            
            testRef.setData([
                "timestamp": Timestamp(date: Date()),
                "message": "Connection test",
                "bundleID": Bundle.main.bundleIdentifier ?? "unknown"
            ]) { error in
                if let error = error {
                    print("   ❌ WRITE FAILED:")
                    print("      Error: \(error.localizedDescription)")
                    print("      Code: \((error as NSError).code)")
                    print("      Domain: \((error as NSError).domain)")
                } else {
                    print("   ✅ Write successful! Attempting read...")
                    
                    testRef.getDocument { snapshot, error in
                        if let error = error {
                            print("   ❌ READ FAILED: \(error.localizedDescription)")
                        } else if let snapshot = snapshot, snapshot.exists {
                            print("   ✅ Read successful! Firebase is FULLY connected!")
                            print("   Data: \(snapshot.data() ?? [:])")
                        } else {
                            print("   ⚠️ Document doesn't exist")
                        }
                    }
                }
            }
        }
        
        // Seed quizzes
        UserDefaults.standard.removeObject(forKey: "quizzes_seeded_v1")
        UserDefaults.standard.removeObject(forKey: "quizzes_seeded_v2")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            print("\n⏰ Starting quiz seeding...")
            QuizSeeder.shared.seedQuizzesIfNeeded()
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
        }
    }
}
