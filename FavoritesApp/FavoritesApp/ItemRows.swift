//
//  ItemRows.swift
//  FavoritesApp
//
//  Created by Meghan Rockwood on 11/2/25.
//


import SwiftUI

// MARK: - City Row
struct CityRow: View {
    @EnvironmentObject var viewModel: FavoritesViewModel
    let city: City
    
    var body: some View {
        HStack {
            Image(systemName: city.imageName)
                .font(.title2)
                .foregroundStyle(.blue)
                .frame(width: 50, height: 50)
                .background(Color.blue.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(city.name)
                    .font(.headline)
                Text(city.country)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    viewModel.toggleFavorite(city: city)
                }
            } label: {
                Image(systemName: viewModel.isFavorite(city: city) ? "heart.fill" : "heart")
                    .font(.title3)
                    .foregroundStyle(viewModel.isFavorite(city: city) ? .red : .gray)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

// MARK: - Hobby Row
struct HobbyRow: View {
    @EnvironmentObject var viewModel: FavoritesViewModel
    let hobby: Hobby
    
    var body: some View {
        HStack {
            Image(systemName: hobby.imageName)
                .font(.title2)
                .foregroundStyle(.orange)
                .frame(width: 50, height: 50)
                .background(Color.orange.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(hobby.name)
                    .font(.headline)
                Text(hobby.category)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    viewModel.toggleFavorite(hobby: hobby)
                }
            } label: {
                Image(systemName: viewModel.isFavorite(hobby: hobby) ? "heart.fill" : "heart")
                    .font(.title3)
                    .foregroundStyle(viewModel.isFavorite(hobby: hobby) ? .red : .gray)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

// MARK: - Book Row
struct BookRow: View {
    @EnvironmentObject var viewModel: FavoritesViewModel
    let book: Book
    
    var body: some View {
        HStack {
            Image(systemName: book.imageName)
                .font(.title2)
                .foregroundStyle(.green)
                .frame(width: 50, height: 50)
                .background(Color.green.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(book.title)
                    .font(.headline)
                    .lineLimit(1)
                Text(book.author)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    viewModel.toggleFavorite(book: book)
                }
            } label: {
                Image(systemName: viewModel.isFavorite(book: book) ? "heart.fill" : "heart")
                    .font(.title3)
                    .foregroundStyle(viewModel.isFavorite(book: book) ? .red : .gray)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

#Preview("City Row") {
    CityRow(city: City(name: "Paris", country: "France", imageName: "photo"))
        .environmentObject(FavoritesViewModel())
        .padding()
}

#Preview("Hobby Row") {
    HobbyRow(hobby: Hobby(name: "Photography", category: "Creative", imageName: "camera"))
        .environmentObject(FavoritesViewModel())
        .padding()
}

#Preview("Book Row") {
    BookRow(book: Book(title: "1984", author: "George Orwell", imageName: "book.closed"))
        .environmentObject(FavoritesViewModel())
        .padding()
}
