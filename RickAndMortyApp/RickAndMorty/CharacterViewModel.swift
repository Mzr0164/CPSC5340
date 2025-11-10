//
//  CharacterViewModel.swift
//  RickAndMortyApp
//
//  Created by Meghan Rockwood on 11/5/25.
//  ViewModel for managing character data
//

import Foundation

@MainActor
class CharacterViewModel: ObservableObject {
    @Published var characters: [Character] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let apiService = APIService.shared
    
    func loadCharacters() async {
        isLoading = true
        errorMessage = nil
        
        do {
            characters = try await apiService.fetchCharacters()
        } catch {
            errorMessage = "Failed to load characters: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
}
