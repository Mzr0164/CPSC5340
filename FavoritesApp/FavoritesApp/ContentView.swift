//
//  ContentView.swift
//  FavoritesApp
//
//  Created by Meghan Rockwood on 11/2/25.
//


import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = FavoritesViewModel()
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            FavoritesView()
                .tabItem {
                    Label("Favorites", systemImage: "heart.fill")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
        .environmentObject(viewModel)
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}

#Preview {
    ContentView()
}
