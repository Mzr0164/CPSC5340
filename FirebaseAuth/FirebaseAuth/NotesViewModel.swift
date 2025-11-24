//
//  NotesViewModel.swift
//  FirebaseAuth
//
//  Created by Jade Rockwood on 11/23/25.
//


//
//  NotesViewModel.swift
//  FirebaseAuth
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

@MainActor
class NotesViewModel: ObservableObject {
    @Published var notes: [Note] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showError = false
    
    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?
    
    // MARK: - Fetch Notes
    func fetchNotes() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("No user signed in")
            return
        }
        
        isLoading = true
        
        // Set up real-time listener
        listener = db.collection("notes")
            .whereField("userId", isEqualTo: userId)
            .order(by: "updatedAt", descending: true)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                
                Task { @MainActor in
                    self.isLoading = false
                    
                    if let error = error {
                        self.errorMessage = "Failed to load notes: \(error.localizedDescription)"
                        self.showError = true
                        print("Error fetching notes: \(error)")
                        return
                    }
                    
                    guard let documents = snapshot?.documents else {
                        self.notes = []
                        return
                    }
                    
                    self.notes = documents.compactMap { document -> Note? in
                        try? document.data(as: Note.self)
                    }
                    
                    print("✅ Loaded \(self.notes.count) notes")
                }
            }
    }
    
    // MARK: - Add Note
    func addNote(title: String, content: String) {
        guard let userId = Auth.auth().currentUser?.uid else {
            errorMessage = "You must be signed in to create notes"
            showError = true
            return
        }
        
        let note = Note(title: title, content: content, userId: userId)
        
        do {
            _ = try db.collection("notes").addDocument(from: note)
            print("✅ Note added successfully")
        } catch {
            errorMessage = "Failed to create note: \(error.localizedDescription)"
            showError = true
            print("❌ Error adding note: \(error)")
        }
    }
    
    // MARK: - Update Note
    func updateNote(_ note: Note, title: String, content: String) {
        guard let noteId = note.id else {
            errorMessage = "Invalid note"
            showError = true
            return
        }
        
        guard let userId = Auth.auth().currentUser?.uid, note.userId == userId else {
            errorMessage = "You don't have permission to edit this note"
            showError = true
            return
        }
        
        let updatedNote = Note(
            id: noteId,
            title: title,
            content: content,
            userId: userId,
            createdAt: note.createdAt,
            updatedAt: Date()
        )
        
        do {
            try db.collection("notes").document(noteId).setData(from: updatedNote)
            print("✅ Note updated successfully")
        } catch {
            errorMessage = "Failed to update note: \(error.localizedDescription)"
            showError = true
            print("❌ Error updating note: \(error)")
        }
    }
    
    // MARK: - Delete Note
    func deleteNote(_ note: Note) {
        guard let noteId = note.id else {
            errorMessage = "Invalid note"
            showError = true
            return
        }
        
        guard let userId = Auth.auth().currentUser?.uid, note.userId == userId else {
            errorMessage = "You don't have permission to delete this note"
            showError = true
            return
        }
        
        db.collection("notes").document(noteId).delete { [weak self] error in
            guard let self = self else { return }
            Task { @MainActor in
                if let error = error {
                    self.errorMessage = "Failed to delete note: \(error.localizedDescription)"
                    self.showError = true
                    print("❌ Error deleting note: \(error)")
                } else {
                    print("✅ Note deleted successfully")
                }
            }
        }
    }
    
    // MARK: - Cleanup
    func stopListening() {
        listener?.remove()
        listener = nil
        notes = []
    }
    
    deinit {
        Task { @MainActor in
            self.stopListening()
        }
    }
}