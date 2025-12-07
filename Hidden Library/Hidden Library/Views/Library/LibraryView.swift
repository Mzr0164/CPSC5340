//
//  LibraryView.swift
//  Hidden Library
//
//  Created by Meghan Rockwood
//
import SwiftUI
import FirebaseFirestore

struct LibraryView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @State private var books: [Book] = []
    @State private var showingAddBook = false
    @State private var selectedBook: Book?
    
    let booksPerShelf = 10
    let shelves = 5
    
    var totalBookSlots: Int {
        shelves * booksPerShelf
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Warm background
                LinearGradient(
                    gradient: Gradient(colors: [Color(red: 0.95, green: 0.92, blue: 0.88), Color(red: 0.92, green: 0.88, blue: 0.82)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 0) {
                        // Stats header
                        HStack {
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Books Reviewed")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text("\(books.count)")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.brown)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing, spacing: 5) {
                                Text("Shelves Filled")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text("\(min(books.count / booksPerShelf + (books.count % booksPerShelf > 0 ? 1 : 0), shelves))/\(shelves)")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.brown)
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.5))
                        .cornerRadius(12)
                        .padding()
                        
                        // Bookshelf
                        VStack(spacing: 30) {
                            ForEach(0..<shelves, id: \.self) { shelfIndex in
                                BookshelfRow(
                                    books: getBooksForShelf(shelfIndex),
                                    shelfIndex: shelfIndex,
                                    onBookTap: { book in
                                        selectedBook = book
                                    }
                                )
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 100)
                    }
                }
                
                // Floating add button
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: { showingAddBook = true }) {
                            Image(systemName: "plus")
                                .font(.title2)
                                .foregroundColor(.white)
                                .frame(width: 60, height: 60)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.brown, Color(red: 0.6, green: 0.4, blue: 0.2)]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .clipShape(Circle())
                                .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                        .padding(.trailing, 30)
                        .padding(.bottom, 30)
                    }
                }
            }
            .navigationTitle("My Library")
            .sheet(isPresented: $showingAddBook) {
                AddBookView(books: $books)
            }
            .sheet(item: $selectedBook) { book in
                BookDetailView(book: book)
            }
            .onAppear {
                fetchBooks()
            }
        }
    }
    
    func getBooksForShelf(_ shelfIndex: Int) -> [Book?] {
        let startIndex = shelfIndex * booksPerShelf
        let endIndex = min(startIndex + booksPerShelf, books.count)
        
        var shelfBooks: [Book?] = []
        
        if startIndex < books.count {
            shelfBooks = books[startIndex..<endIndex].map { $0 }
        }
        
        while shelfBooks.count < booksPerShelf {
            shelfBooks.append(nil)
        }
        
        return shelfBooks
    }
    
    func fetchBooks() {
        guard let userId = authViewModel.user?.id else { return }
        
        Firestore.firestore().collection("books")
            .whereField("userId", isEqualTo: userId)
            .order(by: "createdAt", descending: false)
            .getDocuments { snapshot, error in
                if let documents = snapshot?.documents {
                    books = documents.compactMap { try? $0.data(as: Book.self) }
                }
            }
    }
}
