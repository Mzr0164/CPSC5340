//
//  BookshelfComponents.swift
//  Hidden Library
//
//  Created by Meghan Rockwood
//
import SwiftUI

struct BookshelfRow: View {
    let books: [Book?]
    let shelfIndex: Int
    let onBookTap: (Book) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Books
            HStack(spacing: 2) {
                ForEach(0..<books.count, id: \.self) { index in
                    if let book = books[index] {
                        BookSpine(book: book)
                            .onTapGesture {
                                onBookTap(book)
                            }
                    } else {
                        EmptyBookSlot()
                    }
                }
            }
            .frame(height: 120)
            
            // Shelf
            Rectangle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.4, green: 0.25, blue: 0.1),
                            Color(red: 0.5, green: 0.3, blue: 0.15)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(height: 8)
                .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 2)
        }
    }
}

struct BookSpine: View {
    let book: Book
    
    var spineColor: Color {
        switch book.genre {
        case .fantasy:
            return Color.purple
        case .romance:
            return Color.pink
        case .thriller:
            return Color.red
        case .scienceFiction:
            return Color.blue
        case .mystery:
            return Color.indigo
        case .historical:
            return Color.brown
        case .contemporary:
            return Color.orange
        case .youngAdult:
            return Color.green
        }
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            Text(book.title)
                .font(.system(size: 10, weight: .semibold))
                .foregroundColor(.white)
                .lineLimit(3)
                .multilineTextAlignment(.center)
                .rotationEffect(.degrees(-90))
                .frame(width: 100)
                .padding(.vertical, 8)
            
            Spacer()
            
            // Star rating indicator
            HStack(spacing: 1) {
                ForEach(0..<book.rating, id: \.self) { _ in
                    Image(systemName: "star.fill")
                        .font(.system(size: 6))
                        .foregroundColor(.yellow)
                }
            }
            .rotationEffect(.degrees(-90))
            .padding(.bottom, 5)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 120)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [spineColor, spineColor.opacity(0.7)]),
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .overlay(
            Rectangle()
                .stroke(Color.white.opacity(0.3), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.2), radius: 2, x: 1, y: 0)
    }
}

struct EmptyBookSlot: View {
    var body: some View {
        Rectangle()
            .fill(Color.clear)
            .frame(maxWidth: .infinity)
            .frame(height: 120)
            .overlay(
                RoundedRectangle(cornerRadius: 2)
                    .stroke(Color.gray.opacity(0.2), style: StrokeStyle(lineWidth: 1, dash: [3]))
            )
    }
}
