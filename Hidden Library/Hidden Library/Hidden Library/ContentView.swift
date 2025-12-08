//
//  ContentView.swift
//  Hidden Library
//
//  Created by Meghan Rockwood.
//
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    
    var body: some View {
        Group {
            if authViewModel.isAuthenticated {
                MainTabView()
            } else {
                AuthenticationView()
            }
        }
    }
}

struct MainTabView: View {
    var body: some View {
        TabView {
            LibraryView()
                .tabItem {
                    Label("Library", systemImage: "book.fill")
                }
            
            QuizReviewView()
                .tabItem {
                    Label("Review", systemImage: "checkmark.circle.fill")
                }
            
            DailyQuizzesView()
                .tabItem {
                    Label("Quizzes", systemImage: "gamecontroller.fill")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
        }
    }
}
