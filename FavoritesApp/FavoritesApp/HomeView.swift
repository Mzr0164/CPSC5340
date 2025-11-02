//
//  HomeView.swift
//  FavoritesApp
//
//  Created by Meghan Rockwood on 11/2/25.
//


import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel: FavoritesViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 25) {
                    // Cities Section
                    CategorySection(
                        title: "Cities",
                        icon: "building.2.fill",
                        color: .blue
                    ) {
                        ForEach(viewModel.cities) { city in
                            CityRow(city: city)
                        }
                    }
                    
                    // Hobbies Section
                    CategorySection(
                        title: "Hobbies",
                        icon: "star.fill",
                        color: .orange
                    ) {
                        ForEach(viewModel.hobbies) { hobby in
                            HobbyRow(hobby: hobby)
                        }
                    }
                    
                    // Books Section
                    CategorySection(
                        title: "Books",
                        icon: "book.fill",
                        color: .green
                    ) {
                        ForEach(viewModel.books) { book in
                            BookRow(book: book)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Explore")
        }
    }
}

// MARK: - Category Section
struct CategorySection<Content: View>: View {
    let title: String
    let icon: String
    let color: Color
    let content: Content
    
    init(title: String, icon: String, color: Color, @ViewBuilder content: () -> Content) {
        self.title = title
        self.icon = icon
        self.color = color
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(color)
                    .font(.title2)
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
            }
            .padding(.horizontal)
            
            VStack(spacing: 10) {
                content
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(FavoritesViewModel())
}
