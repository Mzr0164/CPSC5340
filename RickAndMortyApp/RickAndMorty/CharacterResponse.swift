//
//  CharacterResponse.swift
//  RickAndMortyApp
//
//  Created by Meghan Rockwood on 11/5/25.
//  Model for Rick and Morty Character
//

import Foundation

struct CharacterResponse: Codable {
    let results: [Character]
}

struct Character: Codable, Identifiable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let origin: Origin
    let location: Location
    let image: String
    let episode: [String]
    
    struct Origin: Codable {
        let name: String
    }
    
    struct Location: Codable {
        let name: String
    }
}
