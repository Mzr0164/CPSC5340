//
//  FavoritesViewModel.swift
//  FavoritesApp
//
//  Created by Meghan Rockwood on 11/2/25.
//


import Foundation
import SwiftUI

class FavoritesViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var favoriteCities: Set<UUID> = []
    @Published var favoriteHobbies: Set<UUID> = []
    @Published var favoriteBooks: Set<UUID> = []
    
    // MARK: - Hardcoded Data
    let cities: [City] = [
        City(name: "Paris", country: "France", imageName: "photo"),
        City(name: "Tokyo", country: "Japan", imageName: "photo"),
        City(name: "New York", country: "USA", imageName: "photo"),
        City(name: "London", country: "UK", imageName: "photo"),
        City(name: "Barcelona", country: "Spain", imageName: "photo"),
        City(name: "Rome", country: "Italy", imageName: "photo"),
        City(name: "Sydney", country: "Australia", imageName: "photo"),
        City(name: "Dubai", country: "UAE", imageName: "photo")
    ]
    
    let hobbies: [Hobby] = [
        Hobby(name: "Photography", category: "Creative", imageName: "camera"),
        Hobby(name: "Hiking", category: "Outdoor", imageName: "figure.hiking"),
        Hobby(name: "Reading", category: "Indoor", imageName: "book"),
        Hobby(name: "Cooking", category: "Creative", imageName: "fork.knife"),
        Hobby(name: "Gaming", category: "Indoor", imageName: "gamecontroller"),
        Hobby(name: "Painting", category: "Creative", imageName: "paintbrush"),
        Hobby(name: "Cycling", category: "Outdoor", imageName: "bicycle"),
        Hobby(name: "Yoga", category: "Wellness", imageName: "figure.yoga")
    ]
    
    let books: [Book] = [
        Book(title: "To Kill a Mockingbird", author: "Harper Lee", imageName: "book.closed"),
        Book(title: "1984", author: "George Orwell", imageName: "book.closed"),
        Book(title: "The Great Gatsby", author: "F. Scott Fitzgerald", imageName: "book.closed"),
        Book(title: "Pride and Prejudice", author: "Jane Austen", imageName: "book.closed"),
        Book(title: "The Catcher in the Rye", author: "J.D. Salinger", imageName: "book.closed"),
        Book(title: "Harry Potter and the Sorcerer's Stone", author: "J.K. Rowling", imageName: "book.closed"),
        Book(title: "The Lord of the Rings", author: "J.R.R. Tolkien", imageName: "book.closed"),
        Book(title: "The Hobbit", author: "J.R.R. Tolkien", imageName: "book.closed"),
        Book(title: "Brave New World", author: "Aldous Huxley", imageName: "book.closed"),
        Book(title: "The Chronicles of Narnia", author: "C.S. Lewis", imageName: "book.closed")
    ]
    
    // MARK: - Favorite Management Methods
    func isFavorite(city: City) -> Bool {
        favoriteCities.contains(city.id)
    }
    
    func isFavorite(hobby: Hobby) -> Bool {
        favoriteHobbies.contains(hobby.id)
    }
    
    func isFavorite(book: Book) -> Bool {
        favoriteBooks.contains(book.id)
    }
    
    func toggleFavorite(city: City) {
        if favoriteCities.contains(city.id) {
            favoriteCities.remove(city.id)
        } else {
            favoriteCities.insert(city.id)
        }
    }
    
    func toggleFavorite(hobby: Hobby) {
        if favoriteHobbies.contains(hobby.id) {
            favoriteHobbies.remove(hobby.id)
        } else {
            favoriteHobbies.insert(hobby.id)
        }
    }
    
    func toggleFavorite(book: Book) {
        if favoriteBooks.contains(book.id) {
            favoriteBooks.remove(book.id)
        } else {
            favoriteBooks.insert(book.id)
        }
    }
    
    func clearAllFavorites() {
        favoriteCities.removeAll()
        favoriteHobbies.removeAll()
        favoriteBooks.removeAll()
    }
    
    // MARK: - Get Favorite Items
    func getFavoriteCities() -> [City] {
        cities.filter { favoriteCities.contains($0.id) }
    }
    
    func getFavoriteHobbies() -> [Hobby] {
        hobbies.filter { favoriteHobbies.contains($0.id) }
    }
    
    func getFavoriteBooks() -> [Book] {
        books.filter { favoriteBooks.contains($0.id) }
    }
    
    var hasAnyFavorites: Bool {
        !favoriteCities.isEmpty || !favoriteHobbies.isEmpty || !favoriteBooks.isEmpty
    }
}
