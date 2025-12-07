//
//  AddBookView.swift
//  Hidden Library
//
//  Created by Meghan Rockwood
//
import SwiftUI
import FirebaseFirestore
import FirebaseStorage

struct AddBookView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @Binding var books: [Book]
    
    @State private var title = ""
    @State private var author = ""
    @State private var genre: BookGenre = .fantasy
    @State private var rating = 3
    @State private var comment = ""
    @State private var quizQuestion = ""
    @State private var quizOptions = ["", ""]
    @State private var correctAnswerIndex = 0
    @State private var selectedImage: UIImage?
    @State private var showingImagePicker = false
    @State private var isSaving = false
    
    var body: some View {
        NavigationView {
            Form {
                Section("Book Details") {
                    TextField("Title", text: $title)
                    TextField("Author", text: $author)
                    
                    Picker("Genre", selection: $genre) {
                        ForEach(BookGenre.allCases, id: \.self) { genre in
                            Text(genre.rawValue).tag(genre)
                        }
                    }
                }
                
                Section("Cover Photo") {
                    Button(action: { showingImagePicker = true }) {
                        if let image = selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 200)
                        } else {
                            Label("Add Photo", systemImage: "camera")
                        }
                    }
                }
                
                Section("Rating") {
                    HStack {
                        ForEach(1...5, id: \.self) { index in
                            Image(systemName: index <= rating ? "star.fill" : "star")
                                .foregroundColor(.yellow)
                                .onTapGesture {
                                    rating = index
                                }
                        }
                    }
                }
                
                Section("Your Thoughts") {
                    TextEditor(text: $comment)
                        .frame(height: 100)
                }
                
                Section(header: Text("Create a Quiz Question"), footer: Text("Create a true/false or either/or question about the book")) {
                    TextField("Question", text: $quizQuestion)
                    
                    ForEach(0..<2) { index in
                        HStack {
                            TextField("Option \(index + 1)", text: $quizOptions[index])
                            
                            if index == correctAnswerIndex {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                            } else {
                                Image(systemName: "circle")
                                    .foregroundColor(.gray)
                                    .onTapGesture {
                                        correctAnswerIndex = index
                                    }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Add Book")
            .navigationBarItems(
                leading: Button("Cancel") { dismiss() },
                trailing: Button("Save") { saveBook() }
                    .disabled(isSaving)
            )
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $selectedImage)
            }
        }
    }
    
    func saveBook() {
        guard let userId = authViewModel.user?.id,
              let username = authViewModel.user?.username else { return }
        
        isSaving = true
        
        let bookId = UUID().uuidString
        let db = Firestore.firestore()
        
        let book = Book(
            id: bookId,
            userId: userId,
            title: title,
            author: author,
            genre: genre,
            rating: rating,
            comment: comment,
            createdAt: Date()
        )
        
        if let image = selectedImage {
            uploadImage(image: image, bookId: bookId) { imageURL in
                var updatedBook = book
                updatedBook.coverImageURL = imageURL
                saveBookToFirestore(book: updatedBook, db: db, username: username)
            }
        } else {
            saveBookToFirestore(book: book, db: db, username: username)
        }
    }
    
    func saveBookToFirestore(book: Book, db: Firestore, username: String) {
        do {
            try db.collection("books").document(book.id).setData(from: book)
            
            let question = QuizQuestion(
                id: UUID().uuidString,
                bookId: book.id,
                bookTitle: book.title,
                userId: book.userId,
                username: username,
                genre: book.genre,
                question: quizQuestion,
                options: quizOptions,
                correctAnswer: correctAnswerIndex,
                approvalVotes: 0,
                isApproved: false,
                votedUserIds: [],
                createdAt: Date()
            )
            
            try db.collection("quizQuestions").document(question.id).setData(from: question)
            
            books.append(book)
            isSaving = false
            dismiss()
        } catch {
            print("Error saving: \(error)")
            isSaving = false
        }
    }
    
    func uploadImage(image: UIImage, bookId: String, completion: @escaping (String?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            completion(nil)
            return
        }
        
        let storage = Storage.storage()
        let ref = storage.reference().child("bookCovers/\(bookId).jpg")
        
        ref.putData(imageData, metadata: nil) { _, error in
            if error != nil {
                completion(nil)
                return
            }
            
            ref.downloadURL { url, _ in
                completion(url?.absoluteString)
            }
        }
    }
}
