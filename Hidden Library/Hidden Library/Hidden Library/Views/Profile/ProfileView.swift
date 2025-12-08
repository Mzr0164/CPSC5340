//
//  ProfileView.swift
//  Hidden Library
//
//  Created by Meghan Rockwood
//
import SwiftUI
import FirebaseFirestore

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @State private var recentResults: [QuizResult] = []
    @State private var totalBooks = 0
    @State private var showingEditProfile = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    // Profile Header
                    VStack(spacing: 15) {
                        // Profile Photo
                        if let imageURL = authViewModel.user?.profileImageURL {
                            AsyncImage(url: URL(string: imageURL)) { image in
                                image.resizable()
                                    .aspectRatio(contentMode: .fill)
                            } placeholder: {
                                Circle()
                                    .fill(Color.gray.opacity(0.3))
                            }
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.blue, lineWidth: 3))
                            .shadow(radius: 5)
                        } else {
                            ZStack {
                                Circle()
                                    .fill(LinearGradient(
                                        gradient: Gradient(colors: [Color.blue, Color.purple]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ))
                                    .frame(width: 120, height: 120)
                                
                                Text((authViewModel.user?.username.prefix(1) ?? "U").uppercased())
                                    .font(.system(size: 50, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            .shadow(radius: 5)
                        }
                        
                        Text(authViewModel.user?.username ?? "")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text(authViewModel.user?.email ?? "")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        if let bio = authViewModel.user?.bio, !bio.isEmpty {
                            Text(bio)
                                .font(.body)
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        
                        Button(action: { showingEditProfile = true }) {
                            Label("Edit Profile", systemImage: "pencil")
                                .font(.subheadline)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Color.blue.opacity(0.1))
                                .foregroundColor(.blue)
                                .cornerRadius(20)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(radius: 2)
                    .padding(.horizontal)
                    
                    // Stats Grid
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                        StatCard(
                            title: "Total Points",
                            value: "\(authViewModel.user?.points ?? 0)",
                            icon: "star.fill",
                            color: .yellow
                        )
                        
                        StatCard(
                            title: "Books Read",
                            value: "\(totalBooks)",
                            icon: "book.fill",
                            color: .blue
                        )
                        
                        StatCard(
                            title: "Quizzes Taken",
                            value: "\(recentResults.count)",
                            icon: "gamecontroller.fill",
                            color: .green
                        )
                    }
                    .padding(.horizontal)
                    
                    // Favorites Section
                    if let favoriteGenres = authViewModel.user?.favoriteGenres, !favoriteGenres.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            Label("Favorite Genres", systemImage: "heart.fill")
                                .font(.headline)
                                .foregroundColor(.pink)
                            
                            Text(favoriteGenres)
                                .font(.body)
                                .foregroundColor(.primary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(radius: 2)
                        .padding(.horizontal)
                    }
                    
                    if let favoriteBooks = authViewModel.user?.favoriteBooks, !favoriteBooks.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            Label("Favorite Books", systemImage: "bookmark.fill")
                                .font(.headline)
                                .foregroundColor(.orange)
                            
                            Text(favoriteBooks)
                                .font(.body)
                                .foregroundColor(.primary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(radius: 2)
                        .padding(.horizontal)
                    }
                    
                    // Recent Quiz Results
                    if !recentResults.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Recent Quiz Results")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            ForEach(recentResults.prefix(5)) { result in
                                QuizResultCard(result: result)
                            }
                        }
                        .padding(.vertical)
                    }
                    
                    // Sign Out Button
                    Button(action: {
                        authViewModel.signOut()
                    }) {
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                            Text("Sign Out")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red.opacity(0.1))
                        .foregroundColor(.red)
                        .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 30)
                }
                .padding(.vertical)
            }
            .background(Color(UIColor.systemGroupedBackground))
            .navigationTitle("Profile")
            .sheet(isPresented: $showingEditProfile) {
                EditProfileView()
            }
            .onAppear {
                fetchRecentResults()
                fetchTotalBooks()
            }
        }
    }
    
    func fetchRecentResults() {
        guard let userId = authViewModel.user?.id else { return }
        
        Firestore.firestore().collection("quizResults")
            .whereField("userId", isEqualTo: userId)
            .order(by: "completedAt", descending: true)
            .limit(to: 10)
            .getDocuments { snapshot, error in
                if let documents = snapshot?.documents {
                    recentResults = documents.compactMap { try? $0.data(as: QuizResult.self) }
                }
            }
    }
    
    func fetchTotalBooks() {
        guard let userId = authViewModel.user?.id else { return }
        
        Firestore.firestore().collection("books")
            .whereField("userId", isEqualTo: userId)
            .getDocuments { snapshot, error in
                totalBooks = snapshot?.documents.count ?? 0
            }
    }
}
