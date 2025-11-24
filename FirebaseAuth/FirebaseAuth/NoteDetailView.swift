//
//  NoteDetailView.swift
//  FirebaseAuth
//
//  Created by Jade Rockwood on 11/23/25.
//


//
//  NoteDetailView.swift
//  Notes App with Firebase Authentication
//

import SwiftUI

struct NoteDetailView: View {
    @EnvironmentObject var notesViewModel: NotesViewModel
    @Environment(\.dismiss) var dismiss
    
    let note: Note
    
    @State private var title: String
    @State private var content: String
    @State private var isEditing = false
    @State private var showDeleteConfirmation = false
    @FocusState private var focusedField: Field?
    
    enum Field {
        case title, content
    }
    
    init(note: Note) {
        self.note = note
        _title = State(initialValue: note.title)
        _content = State(initialValue: note.content)
    }
    
    var hasChanges: Bool {
        title != note.title || content != note.content
    }
    
    var body: some View {
        Form {
            Section(header: Text("Title")) {
                if isEditing {
                    TextField("Note title", text: $title)
                        .focused($focusedField, equals: .title)
                } else {
                    Text(note.title)
                        .font(.headline)
                }
            }
            
            Section(header: Text("Content")) {
                if isEditing {
                    TextEditor(text: $content)
                        .focused($focusedField, equals: .content)
                        .frame(minHeight: 200)
                } else {
                    if note.content.isEmpty {
                        Text("No content")
                            .foregroundColor(.secondary)
                            .italic()
                    } else {
                        Text(note.content)
                    }
                }
            }
            
            Section(header: Text("Information")) {
                HStack {
                    Text("Created")
                    Spacer()
                    Text(formatDate(note.createdAt))
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text("Last Modified")
                    Spacer()
                    Text(note.formattedDate)
                        .foregroundColor(.secondary)
                }
            }
        }
        .navigationTitle("Note Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    if isEditing {
                        Button(action: saveChanges) {
                            Label("Save Changes", systemImage: "checkmark")
                        }
                        .disabled(!hasChanges || title.trimmingCharacters(in: .whitespaces).isEmpty)
                        
                        Button(action: cancelEditing) {
                            Label("Cancel", systemImage: "xmark")
                        }
                    } else {
                        Button(action: startEditing) {
                            Label("Edit Note", systemImage: "pencil")
                        }
                    }
                    
                    Divider()
                    
                    Button(role: .destructive, action: {
                        showDeleteConfirmation = true
                    }) {
                        Label("Delete Note", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .confirmationDialog("Delete Note", isPresented: $showDeleteConfirmation) {
            Button("Delete", role: .destructive) {
                notesViewModel.deleteNote(note)
                dismiss()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete this note? This action cannot be undone.")
        }
    }
    
    private func startEditing() {
        isEditing = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            focusedField = .title
        }
    }
    
    private func cancelEditing() {
        title = note.title
        content = note.content
        isEditing = false
        focusedField = nil
    }
    
    private func saveChanges() {
        let trimmedTitle = title.trimmingCharacters(in: .whitespaces)
        let trimmedContent = content.trimmingCharacters(in: .whitespaces)
        
        guard !trimmedTitle.isEmpty else { return }
        
        notesViewModel.updateNote(note, title: trimmedTitle, content: trimmedContent)
        isEditing = false
        focusedField = nil
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct NoteDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NoteDetailView(note: Note(
                title: "Sample Note",
                content: "This is a sample note content.",
                userId: "user123"
            ))
            .environmentObject(NotesViewModel())
        }
    }
}