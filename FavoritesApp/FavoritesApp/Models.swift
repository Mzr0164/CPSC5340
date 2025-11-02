//
//  Models.swift
//  FavoritesApp
//
//  Created by Meghan Rockwood on 11/2/25.
//


import Foundation

// MARK: - City Model
struct City: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let country: String
    let imageName: String
}

// MARK: - Hobby Model
struct Hobby: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let category: String
    let imageName: String
}

// MARK: - Book Model
struct Book: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let author: String
    let imageName: String
}

// MARK: - FavoriteItem Protocol
protocol FavoriteItem: Identifiable, Hashable {
    var id: UUID { get }
}

extension City: FavoriteItem {}
extension Hobby: FavoriteItem {}
extension Book: FavoriteItem {}
