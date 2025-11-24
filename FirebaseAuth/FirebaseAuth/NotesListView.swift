//
//  NotesListView.swift
//  FirebaseAuth
//
//  Created by Jade Rockwood on 11/23/25.
//


//
//  NotesListView.swift
//  FirebaseAuth
//

import SwiftUI

struct NotesListView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var notesViewModel = NotesViewModel()
    @State private var showAddNote = false
    @State private var showLogoutConfirmation = false
    @State private var searchText = ""
    
    var filteredNotes: [Note] {
        if searchText.isEmpty {
            return notesViewModel.notes
        } else {
            return notesViewModel.notes.filter { note in
                note.title.localizedCaseInsensitiveContains(searchText) ||
                note.content.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                if notesViewModel.isLoading {
                    ProgressView("Loading notes...")
                } else if filteredNotes.isEmpty {
                    EmptyStateView(searchText: searchText)
                } else {
                    List {
                        ForEach(filteredNotes) { note in
                            NavigationLink(destination: NoteDetailView(note: note)
                                .environmentObject(notesViewModel)) {
                                NoteRowView(note: note)
                            }
                        }
                        .onDelete(perform: deleteNotes)
                    }
                    .listStyle(.insetGrouped)
                    .searchable(text: $searchText, prompt: "Search notes")
                }
            }
            .navigationTitle("My Notes")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if let email = authViewModel.userSession?.email {
                        Menu {
                            Text(email)
                            Divider()
                            Button(role: .destructive, action: {
                                showLogoutConfirmation = true
                            }) {
                                Label("Sign Out", systemImage: "rectangle.portrait.and.arrow.right")
                            }
                        } label: {
                            Image(systemName: "person.circle.fill")
                                .font(.title3)
                        }
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showAddNote = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                    }
                }
            }
            .sheet(isPresented: $showAddNote) {
                AddNoteView()
                    .environmentObject(notesViewModel)
            }
            .confirmationDialog("Sign Out", isPresented: $showLogoutConfirmation) {
                Button("Sign Out", role: .destructive) {
                    Task { @MainActor in
                        notesViewModel.stopListening()
                        authViewModel.signOut()
                    }
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Are you sure you want to sign out?")
            }
            .alert("Error", isPresented: $notesViewModel.showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(notesViewModel.errorMessage ?? "An unknown error occurred")
            }
            .onAppear {
                notesViewModel.fetchNotes()
            }
        }
    }
    
    private func deleteNotes(at offsets: IndexSet) {
        for index in offsets {
            let note = filteredNotes[index]
            notesViewModel.deleteNote(note)
        }
    }
}

// MARK: - Note Row View
struct NoteRowView: View {
    let note: Note
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(note.title)
                .font(.headline)
                .foregroundColor(.primary)
                .lineLimit(1)
            
            if !note.content.isEmpty {
                Text(note.content)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            Text(note.formattedDate)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Empty State View
struct EmptyStateView: View {
    let searchText: String
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: searchText.isEmpty ? "note.text" : "magnifyingglass")
                .font(.system(size: 70))
                .foregroundColor(.gray)
            
            Text(searchText.isEmpty ? "No Notes Yet" : "No Results")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text(searchText.isEmpty ? "Tap the + button to create your first note" : "Try a different search term")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
    }
}

struct NotesListView_Previews: PreviewProvider {
    static var previews: some View {
        NotesListView()
            .environmentObject(AuthViewModel())
    }
}