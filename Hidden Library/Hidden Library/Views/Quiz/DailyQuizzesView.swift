//
//  DailyQuizzesView.swift
//  Hidden Library
//
//  Created by Meghan Rockwood
//
import SwiftUI

struct DailyQuizzesView: View {
    @State private var selectedGenre: BookGenre?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Daily Genre Quizzes")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.top)
                    
                    Text("Test your knowledge with 10 questions per genre")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    VStack(spacing: 15) {
                        ForEach(BookGenre.allCases, id: \.self) { genre in
                            GenreQuizCard(genre: genre) {
                                selectedGenre = genre
                            }
                        }
                    }
                    .padding()
                }
            }
            .background(Color(UIColor.systemGroupedBackground))
            .navigationTitle("Quizzes")
            .sheet(item: $selectedGenre) { genre in
                QuizView(genre: genre)
            }
        }
    }
}
