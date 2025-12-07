//
//  EditProfileView.swift
//  Hidden Library
//
//  Created by Meghan Rockwood
//
import SwiftUI
import FirebaseFirestore
import FirebaseStorage

struct EditProfileView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    
    @State private var bio: String
    @State private var favoriteGenres: String
    @State private var favoriteBooks: String
    @State private var selectedImage: UIImage?
    @State private var showingImagePicker = false
    @State private var isSaving = false
    
    init() {
        _bio = State(initialValue: "")
        _favoriteGenres = State(initialValue: "")
        _favoriteBooks = State(initialValue: "")
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("Profile Photo") {
                    Button(action: { showingImagePicker = true }) {
                        HStack {
                            Spacer()
                            if let image = selectedImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 120, height: 120)
                                    .clipShape(Circle())
                            } else if let imageURL = authViewModel.user?.profileImageURL {
                                AsyncImage(url: URL(string: imageURL)) { image in
                                    image.resizable()
                                        .aspectRatio(contentMode: .fill)
                                } placeholder: {
                                    Circle()
                                        .fill(Color.gray.opacity(0.3))
                                }
                                .frame(width: 120, height: 120)
                                .clipShape(Circle())
                            } else {
                                ZStack {
                                    Circle()
                                        .fill(Color.blue.opacity(0.2))
                                        .frame(width: 120, height: 120)
                                    
                                    Image(systemName: "camera.fill")
                                        .font(.largeTitle)
                                        .foregroundColor(.blue)
                                }
                            }
                            Spacer()
                        }
                    }
                }
                
                Section(header: Text("About Me"), footer: Text("Tell other readers about yourself")) {
                    TextEditor(text: $bio)
                        .frame(height: 100)
                }
                
                Section(header: Text("Favorite Genres"), footer: Text("e.g., Fantasy, Mystery, Romance")) {
                    TextEditor(text: $favoriteGenres)
                        .frame(height: 60)
                }
                
                Section(header: Text("Favorite Books"), footer: Text("Share your all-time favorites")) {
                    TextEditor(text: $favoriteBooks)
                        .frame(height: 80)
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarItems(
                leading: Button("Cancel") { dismiss() },
                trailing: Button("Save") { saveProfile() }
                    .disabled(isSaving)
            )
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $selectedImage)
            }
            .onAppear {
                bio = authViewModel.user?.bio ?? ""
                favoriteGenres = authViewModel.user?.favoriteGenres ?? ""
                favoriteBooks = authViewModel.user?.favoriteBooks ?? ""
            }
        }
    }
    
    func saveProfile() {
        guard let userId = authViewModel.user?.id else { return }
        
        isSaving = true
        let db = Firestore.firestore()
        
        var updateData: [String: Any] = [
            "bio": bio,
            "favoriteGenres": favoriteGenres,
            "favoriteBooks": favoriteBooks
        ]
        
        if let image = selectedImage {
            uploadProfileImage(image: image, userId: userId) { imageURL in
                if let imageURL = imageURL {
                    updateData["profileImageURL"] = imageURL
                }
                updateUserData(updateData: updateData, db: db, userId: userId)
            }
        } else {
            updateUserData(updateData: updateData, db: db, userId: userId)
        }
    }
    
    func updateUserData(updateData: [String: Any], db: Firestore, userId: String) {
        db.collection("users").document(userId).updateData(updateData) { error in
            if error == nil {
                authViewModel.fetchUserData(userId: userId)
            }
            isSaving = false
            dismiss()
        }
    }
    
    func uploadProfileImage(image: UIImage, userId: String, completion: @escaping (String?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            completion(nil)
            return
        }
        
        let storage = Storage.storage()
        let ref = storage.reference().child("profilePhotos/\(userId).jpg")
        
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
