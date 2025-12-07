//
//  QuizResultView.swift
//  Hidden Library
//
//  Created by Meghan Rockwood
//
import SwiftUI

struct QuizResultView: View {
    let score: Int
    let totalQuestions: Int
    let genre: BookGenre
    let onDismiss: () -> Void
    
    var pointsEarned: Int {
        score * 10
    }
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Quiz Complete!")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text(genre.rawValue)
                .font(.title2)
                .foregroundColor(.secondary)
            
            VStack(spacing: 10) {
                Text("\(score)/\(totalQuestions)")
                    .font(.system(size: 60, weight: .bold))
                    .foregroundColor(.blue)
                
                Text("Correct Answers")
                    .foregroundColor(.secondary)
            }
            
            Text("+\(pointsEarned) points")
                .font(.title)
                .foregroundColor(.green)
            
            Button(action: onDismiss) {
                Text("Done")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .padding()
    }
}
