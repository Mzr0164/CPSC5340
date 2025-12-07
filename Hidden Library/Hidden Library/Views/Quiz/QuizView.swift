//
//  QuizView.swift
//  Hidden Library
//
//  Created by Meghan Rockwood
//
import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct QuizView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    let genre: BookGenre
    
    @State private var questions: [QuizQuestion] = []
    @State private var currentQuestionIndex = 0
    @State private var score = 0
    @State private var selectedAnswer: Int?
    @State private var showingResult = false
    @State private var isLoading = true
    
    var genreColors: [Color] {
        switch genre {
        case .fantasy: return [Color.purple, Color.indigo]
        case .romance: return [Color.pink, Color.red]
        case .thriller: return [Color.red, Color.black]
        case .scienceFiction: return [Color.blue, Color.cyan]
        case .mystery: return [Color.indigo, Color.purple]
        case .historical: return [Color.brown, Color.orange]
        case .contemporary: return [Color.orange, Color.yellow]
        case .youngAdult: return [Color.green, Color.mint]
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Themed background
                LinearGradient(
                    gradient: Gradient(colors: genreColors),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack {
                    if isLoading {
                        ProgressView("Loading quiz...")
                            .tint(.white)
                            .foregroundColor(.white)
                    } else if questions.isEmpty {
                        VStack(spacing: 20) {
                            Image(systemName: "book.closed")
                                .font(.system(size: 60))
                                .foregroundColor(.white.opacity(0.7))
                            
                            Text("No questions available yet")
                                .font(.title3)
                                .foregroundColor(.white)
                            
                            Text("Be the first to add a book in this genre!")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                                .multilineTextAlignment(.center)
                        }
                        .padding()
                    } else if showingResult {
                        QuizResultView(score: score, totalQuestions: questions.count, genre: genre) {
                            dismiss()
                        }
                    } else {
                        VStack(spacing: 30) {
                            // Progress bar
                            VStack(spacing: 8) {
                                HStack {
                                    Text("Question \(currentQuestionIndex + 1) of \(questions.count)")
                                        .font(.subheadline)
                                        .foregroundColor(.white.opacity(0.9))
                                    Spacer()
                                    Text("Score: \(score)")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                }
                                
                                GeometryReader { geometry in
                                    ZStack(alignment: .leading) {
                                        Rectangle()
                                            .fill(Color.white.opacity(0.3))
                                            .frame(height: 8)
                                            .cornerRadius(4)
                                        
                                        Rectangle()
                                            .fill(Color.white)
                                            .frame(width: geometry.size.width * CGFloat(currentQuestionIndex + 1) / CGFloat(questions.count), height: 8)
                                            .cornerRadius(4)
                                    }
                                }
                                .frame(height: 8)
                            }
                            .padding()
                            .background(Color.black.opacity(0.2))
                            .cornerRadius(12)
                            
                            Spacer()
                            
                            // Question
                            Text(questions[currentQuestionIndex].question)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                            
                            Spacer()
                            
                            // Two answer options
                            VStack(spacing: 20) {
                                ForEach(0..<2, id: \.self) { index in
                                    Button(action: {
                                        selectedAnswer = index
                                    }) {
                                        HStack {
                                            Text(questions[currentQuestionIndex].options[index])
                                                .font(.headline)
                                                .foregroundColor(selectedAnswer == index ? genreColors[0] : .white)
                                                .multilineTextAlignment(.leading)
                                            
                                            Spacer()
                                            
                                            if selectedAnswer == index {
                                                Image(systemName: "checkmark.circle.fill")
                                                    .foregroundColor(genreColors[0])
                                                    .font(.title3)
                                            }
                                        }
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(
                                            selectedAnswer == index ?
                                                Color.white :
                                                Color.white.opacity(0.2)
                                        )
                                        .cornerRadius(12)
                                    }
                                }
                            }
                            .padding(.horizontal)
                            
                            Spacer()
                            
                            // Next button
                            Button(action: submitAnswer) {
                                Text(currentQuestionIndex < questions.count - 1 ? "Next Question" : "Finish Quiz")
                                    .font(.headline)
                                    .foregroundColor(genreColors[0])
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(12)
                            }
                            .disabled(selectedAnswer == nil)
                            .opacity(selectedAnswer == nil ? 0.5 : 1)
                            .padding(.horizontal)
                            .padding(.bottom, 30)
                        }
                    }
                }
            }
            .navigationTitle(genre.rawValue)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Exit") { dismiss() }
                        .foregroundColor(.white)
                }
            }
            .onAppear {
                fetchQuestions()
            }
        }
    }
    
    func fetchQuestions() {
        Firestore.firestore().collection("quizQuestions")
            .whereField("genre", isEqualTo: genre.rawValue)
            .whereField("isApproved", isEqualTo: true)
            .limit(to: 10)
            .getDocuments { snapshot, error in
                if let documents = snapshot?.documents {
                    questions = documents.compactMap { try? $0.data(as: QuizQuestion.self) }.shuffled()
                }
                isLoading = false
            }
    }
    
    func submitAnswer() {
        if let selected = selectedAnswer {
            if selected == questions[currentQuestionIndex].correctAnswer {
                score += 1
            }
        }
        
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
            selectedAnswer = nil
        } else {
            saveResult()
            showingResult = true
        }
    }
    
    func saveResult() {
        guard let userId = authViewModel.user?.id else { return }
        
        let pointsEarned = score * 10
        let result = QuizResult(
            id: UUID().uuidString,
            userId: userId,
            quizId: UUID().uuidString,
            genre: genre,
            score: score,
            totalQuestions: questions.count,
            pointsEarned: pointsEarned,
            completedAt: Date()
        )
        
        let db = Firestore.firestore()
        try? db.collection("quizResults").document(result.id).setData(from: result)
        
        db.collection("users").document(userId).updateData([
            "points": FieldValue.increment(Int64(pointsEarned))
        ])
    }
}
