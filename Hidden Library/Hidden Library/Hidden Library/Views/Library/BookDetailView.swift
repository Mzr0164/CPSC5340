//
//  BookDetailView.swift
//  Hidden Library
//
//  Created by Meghan Rockwood
//
import SwiftUI

struct BookDetailView: View {
    @Environment(\.dismiss) var dismiss
    let book: Book
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Cover image
                    if let imageURL = book.coverImageURL {
                        AsyncImage(url: URL(string: imageURL)) { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fit)
                        } placeholder: {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                        }
                        .frame(height: 300)
                        .cornerRadius(12)
                        .shadow(radius: 5)
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text(book.title)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("by \(book.author)")
                            .font(.title3)
                            .foregroundColor(.secondary)
                        
                        HStack {
                            Text(book.genre.rawValue)
                                .font(.subheadline)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.blue.opacity(0.2))
                                .cornerRadius(8)
                            
                            Spacer()
                            
                            HStack(spacing: 3) {
                                ForEach(0..<5) { index in
                                    Image(systemName: index < book.rating ? "star.fill" : "star")
                                        .foregroundColor(.yellow)
                                }
                            }
                        }
                        
                        Divider()
                            .padding(.vertical, 5)
                        
                        Text("My Thoughts")
                            .font(.headline)
                        
                        Text(book.comment)
                            .font(.body)
                            .foregroundColor(.primary)
                        
                        Text("Added \(book.createdAt, style: .date)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.top, 10)
                    }
                    .padding()
                }
                .padding()
            }
            .navigationTitle("Book Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}
