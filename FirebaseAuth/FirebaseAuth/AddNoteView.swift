//
//  AddNoteView.swift
//  FirebaseAuth
//
//  Created by Jade Rockwood on 11/23/25.
//


//
//  AddNoteView.swift
//  Notes App with Firebase Authentication
//

import SwiftUI

struct AddNoteView: View {
    @EnvironmentObject var notesViewModel: NotesViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var content = ""
    @FocusState private var focusedField: Field?
    
    enum Field {
        case title, content
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Title")) {
                    TextField("Enter note title", text: $title)
                        .focused($focusedField, equals: .title)
                }
                
                Section(header: Text("Content")) {
                    TextEditor(text: $content)
                        .focused($focusedField, equals: .content)
                        .frame(minHeight: 200)
                }
            }
            .navigationTitle("New Note")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveNote()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .onAppear {
                // Auto-focus on title field
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    focusedField = .title
                }
            }
        }
    }
    
    private func saveNote() {
        let trimmedTitle = title.trimmingCharacters(in: .whitespaces)
        let trimmedContent = content.trimmingCharacters(in: .whitespaces)
        
        guard !trimmedTitle.isEmpty else { return }
        
        notesViewModel.addNote(title: trimmedTitle, content: trimmedContent)
        dismiss()
    }
}

struct AddNoteView_Previews: PreviewProvider {
    static var previews: some View {
        AddNoteView()
            .environmentObject(NotesViewModel())
    }
}