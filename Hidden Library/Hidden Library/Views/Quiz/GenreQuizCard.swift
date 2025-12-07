//
//  GenreQuizCard.swift
//  Hidden Library
//
//  Created by Meghan Rockwood
//
import SwiftUI

struct GenreQuizCard: View {
    let genre: BookGenre
    let action: () -> Void
    
    var genreIcon: String {
        switch genre {
        case .fantasy: return "wand.and.stars"
        case .romance: return "heart.fill"
        case .thriller: return "bolt.fill"
        case .scienceFiction: return "sparkles"
        case .mystery: return "magnifyingglass"
        case .historical: return "scroll.fill"
        case .contemporary: return "building.2.fill"
        case .youngAdult: return "figure.walk"
        }
    }
    
    var genreColors: [Color] {
        switch genre {
        case .fantasy:
            return [Color.purple, Color.indigo]
        case .romance:
            return [Color.pink, Color.red]
        case .thriller:
            return [Color.red, Color.black]
        case .scienceFiction:
            return [Color.blue, Color.cyan]
        case .mystery:
            return [Color.indigo, Color.purple]
        case .historical:
            return [Color.brown, Color.orange]
        case .contemporary:
            return [Color.orange, Color.yellow]
        case .youngAdult:
            return [Color.green, Color.mint]
        }
    }
    
    var genrePattern: some View {
        switch genre {
        case .fantasy:
            return AnyView(
                ZStack {
                    ForEach(0..<8) { i in
                        Image(systemName: "star.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.white.opacity(0.1))
                            .offset(x: CGFloat.random(in: -80...80), y: CGFloat.random(in: -40...40))
                    }
                }
            )
        case .romance:
            return AnyView(
                ZStack {
                    ForEach(0..<6) { i in
                        Image(systemName: "heart.fill")
                            .font(.system(size: 25))
                            .foregroundColor(.white.opacity(0.1))
                            .offset(x: CGFloat.random(in: -80...80), y: CGFloat.random(in: -40...40))
                    }
                }
            )
        case .thriller:
            return AnyView(
                ZStack {
                    ForEach(0..<10) { i in
                        Rectangle()
                            .fill(Color.white.opacity(0.05))
                            .frame(width: 2, height: 100)
                            .rotationEffect(.degrees(Double(i) * 18))
                    }
                }
            )
        case .scienceFiction:
            return AnyView(
                ZStack {
                    ForEach(0..<15) { i in
                        Circle()
                            .fill(Color.white.opacity(0.1))
                            .frame(width: CGFloat.random(in: 3...8))
                            .offset(x: CGFloat.random(in: -80...80), y: CGFloat.random(in: -40...40))
                    }
                }
            )
        case .mystery:
            return AnyView(
                ZStack {
                    Image(systemName: "questionmark")
                        .font(.system(size: 60))
                        .foregroundColor(.white.opacity(0.1))
                        .rotationEffect(.degrees(-15))
                }
            )
        default:
            return AnyView(EmptyView())
        }
    }
    
    var body: some View {
        Button(action: action) {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: genreColors),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                
                // Pattern overlay
                genrePattern
                
                // Content
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Image(systemName: genreIcon)
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                        
                        Text(genre.rawValue)
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("10 Questions")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.9))
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.title2)
                        .foregroundColor(.white.opacity(0.7))
                }
                .padding()
            }
            .frame(height: 100)
            .cornerRadius(15)
            .shadow(color: genreColors[0].opacity(0.3), radius: 8, x: 0, y: 4)
        }
    }
}
