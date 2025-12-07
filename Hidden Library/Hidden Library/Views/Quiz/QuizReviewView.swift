//
//  QuizReviewView.swift
//  Hidden Library
//
//  Created by Meghan Rockwood
//
import SwiftUI
import FirebaseFirestore

struct QuizReviewView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @State private var pendingQuestions: [QuizQuestion] = []
    
    var body: some View {
        NavigationView {
            List(pendingQuestions) { question in
                QuizQuestionReviewCard(question: question) {
                    voteForQuestion(question: question)
                }
            }
            .navigationTitle("Review Questions")
            .onAppear {
                fetchPendingQuestions()
            }
        }
    }
    
    func fetchPendingQuestions() {
        Firestore.firestore().collection("quizQuestions")
            .whereField("isApproved", isEqualTo: false)
            .order(by: "createdAt", descending: true)
            .getDocuments { snapshot, error in
                if let documents = snapshot?.documents {
                    pendingQuestions = documents.compactMap { try? $0.data(as: QuizQuestion.self) }
                }
            }
    }
    
    func voteForQuestion(question: QuizQuestion) {
        guard let userId = authViewModel.user?.id else { return }
        
        let db = Firestore.firestore()
        let questionRef = db.collection("quizQuestions").document(question.id)
        
        var updatedVotedUserIds = question.votedUserIds
        updatedVotedUserIds.append(userId)
        
        let newVoteCount = question.approvalVotes + 1
        let isNowApproved = newVoteCount >= 3
        
        questionRef.updateData([
            "approvalVotes": newVoteCount,
            "votedUserIds": updatedVotedUserIds,
            "isApproved": isNowApproved
        ]) { _ in
            fetchPendingQuestions()
        }
    }
}

struct QuizQuestionReviewCard: View {
    let question: QuizQuestion
    let onVote: () -> Void
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    
    var hasVoted: Bool {
        guard let userId = authViewModel.user?.id else { return false }
        return question.votedUserIds.contains(userId)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(question.bookTitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text(question.genre.rawValue)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(5)
            }
            
            Text(question.question)
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(0..<question.options.count, id: \.self) { index in
                    HStack {
                        Text(question.options[index])
                            .font(.subheadline)
                        
                        Spacer()
                        
                        if index == question.correctAnswer {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            
            HStack {
                Text("Votes: \(question.approvalVotes)/3")
                    .font(.caption)
                
                Spacer()
                
                if !hasVoted {
                    Button(action: onVote) {
                        Text("Approve")
                            .font(.caption)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(5)
                    }
                } else {
                    Text("✓ Voted")
                        .font(.caption)
                        .foregroundColor(.green)
                }
            }
        }
        .padding(.vertical, 5)
    }
}
