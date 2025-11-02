//
//  SettingsView.swift
//  FavoritesApp
//
//  Created by Meghan Rockwood on 11/2/25.
//


import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var viewModel: FavoritesViewModel
    @AppStorage("isDarkMode") private var isDarkMode = false
    @State private var showClearAlert = false
    
    var body: some View {
        NavigationStack {
            List {
                // Appearance Section
                Section {
                    Toggle(isOn: $isDarkMode) {
                        HStack {
                            Image(systemName: isDarkMode ? "moon.fill" : "sun.max.fill")
                                .foregroundStyle(isDarkMode ? .purple : .orange)
                                .font(.title3)
                            Text("Dark Mode")
                        }
                    }
                } header: {
                    Text("Appearance")
                } footer: {
                    Text("Switch between light and dark mode")
                }
                
                // Favorites Section
                Section {
                    Button(role: .destructive) {
                        showClearAlert = true
                    } label: {
                        HStack {
                            Image(systemName: "trash.fill")
                            Text("Clear All Favorites")
                        }
                    }
                    .disabled(!viewModel.hasAnyFavorites)
                } header: {
                    Text("Favorites")
                } footer: {
                    if viewModel.hasAnyFavorites {
                        Text("You have \(totalFavoritesCount) favorite items")
                    } else {
                        Text("You have no favorites")
                    }
                }
                
                // About Section
                Section {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundStyle(.secondary)
                    }
                    
                    HStack {
                        Text("Total Cities")
                        Spacer()
                        Text("\(viewModel.cities.count)")
                            .foregroundStyle(.secondary)
                    }
                    
                    HStack {
                        Text("Total Hobbies")
                        Spacer()
                        Text("\(viewModel.hobbies.count)")
                            .foregroundStyle(.secondary)
                    }
                    
                    HStack {
                        Text("Total Books")
                        Spacer()
                        Text("\(viewModel.books.count)")
                            .foregroundStyle(.secondary)
                    }
                } header: {
                    Text("About")
                }
            }
            .navigationTitle("Settings")
            .alert("Clear All Favorites?", isPresented: $showClearAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Clear All", role: .destructive) {
                    withAnimation {
                        viewModel.clearAllFavorites()
                    }
                }
            } message: {
                Text("This will remove all \(totalFavoritesCount) items from your favorites. This action cannot be undone.")
            }
        }
    }
    
    private var totalFavoritesCount: Int {
        viewModel.favoriteCities.count + viewModel.favoriteHobbies.count + viewModel.favoriteBooks.count
    }
}

#Preview {
    SettingsView()
        .environmentObject(FavoritesViewModel())
}
