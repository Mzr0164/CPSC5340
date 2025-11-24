//
//  Note.swift
//  FirebaseAuth
//
//  Created by Jade Rockwood on 11/23/25.
//


//
//  Note.swift
//  Notes App with Firebase Authentication
//

import Foundation
import FirebaseFirestore

struct Note: Identifiable, Codable {
    @DocumentID var id: String?
    var title: String
    var content: String
    var userId: String
    var createdAt: Date
    var updatedAt: Date
    
    // Computed property for display
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: updatedAt)
    }
    
    // Initialize a new note
    init(title: String, content: String, userId: String) {
        self.title = title
        self.content = content
        self.userId = userId
        self.createdAt = Date()
        self.updatedAt = Date()
    }
    
    // For decoding from Firestore
    init(id: String? = nil, title: String, content: String, userId: String, createdAt: Date, updatedAt: Date) {
        self.id = id
        self.title = title
        self.content = content
        self.userId = userId
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}