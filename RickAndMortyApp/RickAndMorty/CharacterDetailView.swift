//
//  CharacterDetailView.swift
//  RickAndMortyApp
//
//  Created by Meghan Rockwood on 11/5/25.
//  Detail view for individual character
//

import SwiftUI

struct CharacterDetailView: View {
    let character: Character
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Character Image
                AsyncImage(url: URL(string: character.image)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                }
                .frame(maxWidth: .infinity)
                .frame(height: 300)
                .background(Color.gray.opacity(0.2))
                
                VStack(alignment: .leading, spacing: 16) {
                    // Name
                    Text(character.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    // Status
                    HStack {
                        Text("Status:")
                            .fontWeight(.semibold)
                        HStack {
                            Circle()
                                .fill(statusColor(for: character.status))
                                .frame(width: 10, height: 10)
                            Text(character.status)
                        }
                    }
                    
                    Divider()
                    
                    // Species
                    DetailRow(title: "Species", value: character.species)
                    
                    // Gender
                    DetailRow(title: "Gender", value: character.gender)
                    
                    // Origin
                    DetailRow(title: "Origin", value: character.origin.name)
                    
                    // Last Known Location
                    DetailRow(title: "Last Known Location", value: character.location.name)
                    
                    // Type (if available)
                    if !character.type.isEmpty {
                        DetailRow(title: "Type", value: character.type)
                    }
                    
                    Divider()
                    
                    // Episodes
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Featured in:")
                            .fontWeight(.semibold)
                        Text("\(character.episode.count) episodes")
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func statusColor(for status: String) -> Color {
        switch status.lowercased() {
        case "alive":
            return .green
        case "dead":
            return .red
        default:
            return .gray
        }
    }
}

struct DetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
            Text(value)
                .font(.body)
        }
    }
}

#Preview {
    NavigationStack {
        CharacterDetailView(character: Character(
            id: 1,
            name: "Rick Sanchez",
            status: "Alive",
            species: "Human",
            type: "",
            gender: "Male",
            origin: Character.Origin(name: "Earth (C-137)"),
            location: Character.Location(name: "Citadel of Ricks"),
            image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
            episode: ["Episode 1", "Episode 2"]
        ))
    }
}
