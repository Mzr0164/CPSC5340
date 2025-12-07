//
//  ProfileComponents.swift
//  Hidden Library
//
//  Created by Meghan Rockwood
//
import SwiftUI

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

struct QuizResultCard: View {
    let result: QuizResult
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(result.genre.rawValue)
                    .font(.headline)
                
                Text(result.completedAt, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 5) {
                Text("\(result.score)/\(result.totalQuestions)")
                    .font(.headline)
                    .foregroundColor(.blue)
                
                Text("+\(result.pointsEarned) pts")
                    .font(.caption)
                    .foregroundColor(.green)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
        .padding(.horizontal)
    }
}
