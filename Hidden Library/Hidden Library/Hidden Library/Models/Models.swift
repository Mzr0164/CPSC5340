//
//  Models.swift
//  Hidden Library
//
//  Created by Meghan Rockwood
//
import Foundation

// MARK: - User Model

struct User: Identifiable, Codable {
    var id: String
    var username: String
    var email: String
    var points: Int
    var profileImageURL: String?
    var bio: String?
    var favoriteGenres: String?
    var favoriteBooks: String?
    var createdAt: Date
}

// MARK: - Book Model

struct Book: Identifiable, Codable {
    var id: String
    var userId: String
    var title: String
    var author: String
    var genre: BookGenre
    var rating: Int
    var comment: String
    var coverImageURL: String?
    var createdAt: Date
}

// MARK: - Quiz Question Model

struct QuizQuestion: Identifiable, Codable {
    var id: String
    var bookId: String
    var bookTitle: String
    var userId: String
    var username: String
    var genre: BookGenre
    var question: String
    var options: [String] // Only 2 options
    var correctAnswer: Int // 0 or 1
    var approvalVotes: Int
    var isApproved: Bool
    var votedUserIds: [String]
    var createdAt: Date
}

// MARK: - Daily Quiz Model

struct DailyQuiz: Identifiable, Codable {
    var id: String
    var genre: BookGenre
    var date: String
    var questionIds: [String]
}

// MARK: - Quiz Result Model

struct QuizResult: Identifiable, Codable {
    var id: String
    var userId: String
    var quizId: String
    var genre: BookGenre
    var score: Int
    var totalQuestions: Int
    var pointsEarned: Int
    var completedAt: Date
}

// MARK: - Book Genre Enum

enum BookGenre: String, Codable, CaseIterable, Identifiable {
    case fantasy = "Fantasy"
    case romance = "Romance"
    case thriller = "Thriller"
    case scienceFiction = "Science Fiction"
    case mystery = "Mystery"
    case historical = "Historical"
    case contemporary = "Contemporary"
    case youngAdult = "Young Adult"
    
    var id: String { self.rawValue }
}
