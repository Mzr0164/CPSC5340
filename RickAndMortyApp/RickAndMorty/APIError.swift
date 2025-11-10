//
//  APIError.swift
//  RickAndMortyApp
//
//  Created by Meghan Rockwood on 11/5/25.
//  Service layer for API communication
//

import Foundation

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case decodingError
}

class APIService {
    static let shared = APIService()
    private let baseURL = "https://rickandmortyapi.com/api"
    
    private init() {}
    
    func fetchCharacters() async throws -> [Character] {
        guard let url = URL(string: "\(baseURL)/character") else {
            throw APIError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIError.invalidResponse
        }
        
        do {
            let characterResponse = try JSONDecoder().decode(CharacterResponse.self, from: data)
            return characterResponse.results
        } catch {
            throw APIError.decodingError
        }
    }
}
