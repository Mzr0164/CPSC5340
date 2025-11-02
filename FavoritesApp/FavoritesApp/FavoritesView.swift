//
//  FavoritesView.swift
//  FavoritesApp
//
//  Created by Meghan Rockwood on 11/2/25.
//


import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var viewModel: FavoritesViewModel
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.hasAnyFavorites {
                    ScrollView {
                        VStack(spacing: 25) {
                            // Favorite Cities
                            if !viewModel.getFavoriteCities().isEmpty {
                                FavoriteCategorySection(
                                    title: "Cities",
                                    icon: "building.2.fill",
                                    color: .blue,
                                    count: viewModel.getFavoriteCities().count
                                ) {
                                    ForEach(viewModel.getFavoriteCities()) { city in
                                        CityRow(city: city)
                                    }
                                }
                            }
                            
                            // Favorite Hobbies
                            if !viewModel.getFavoriteHobbies().isEmpty {
                                FavoriteCategorySection(
                                    title: "Hobbies",
                                    icon: "star.fill",
                                    color: .orange,
                                    count: viewModel.getFavoriteHobbies().count
                                ) {
                                    ForEach(viewModel.getFavoriteHobbies()) { hobby in
                                        HobbyRow(hobby: hobby)
                                    }
                                }
                            }
                            
                            // Favorite Books
                            if !viewModel.getFavoriteBooks().isEmpty {
                                FavoriteCategorySection(
                                    title: "Books",
                                    icon: "book.fill",
                                    color: .green,
                                    count: viewModel.getFavoriteBooks().count
                                ) {
                                    ForEach(viewModel.getFavoriteBooks()) { book in
                                        BookRow(book: book)
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                } else {
                    EmptyFavoritesView()
                }
            }
            .navigationTitle("Favorites")
        }
    }
}

// MARK: - Favorite Category Section
struct FavoriteCategorySection<Content: View>: View {
    let title: String
    let icon: String
    let color: Color
    let count: Int
    let content: Content
    
    init(title: String, icon: String, color: Color, count: Int, @ViewBuilder content: () -> Content) {
        self.title = title
        self.icon = icon
        self.color = color
        self.count = count
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(color)
                    .font(.title3)
                Text(title)
                    .font(.title3)
                    .fontWeight(.bold)
                
                Spacer()
                
                Text("\(count)")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(color.opacity(0.15))
                    .clipShape(Capsule())
            }
            .padding(.horizontal)
            
            VStack(spacing: 10) {
                content
            }
        }
    }
}

// MARK: - Empty Favorites View
struct EmptyFavoritesView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "heart.slash")
                .font(.system(size: 70))
                .foregroundStyle(.gray.opacity(0.5))
            
            Text("No Favorites Yet")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Tap the heart icon on cities, hobbies, or books to add them to your favorites")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview("Favorites with Items") {
    FavoritesView()
        .environmentObject({
            let vm = FavoritesViewModel()
            vm.favoriteCities.insert(vm.cities[0].id)
            vm.favoriteCities.insert(vm.cities[1].id)
            vm.favoriteHobbies.insert(vm.hobbies[0].id)
            vm.favoriteBooks.insert(vm.books[0].id)
            vm.favoriteBooks.insert(vm.books[1].id)
            return vm
        }())
}

#Preview("Empty Favorites") {
    FavoritesView()
        .environmentObject(FavoritesViewModel())
}
