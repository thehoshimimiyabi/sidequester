//
//  ActivityDetailView.swift
//  sidequester
//
//  Created by Rayson Ng on 9/7/26.
//

import SwiftUI
import PhotosUI
import FirebaseStorage
import FirebaseAuth

struct ActivityDetailView: View {
    let activity: Activity
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var selectedImage: Image?
    @State private var imageData: Data?
    @State private var showSubmitButton = false
    @State private var showSuccess = false
    @Environment(\.dismiss) private var dismiss
    @State private var animateSuccess = false

    var body: some View {
        ZStack {
            ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(activity.name)
                    .font(.largeTitle)
                    .bold()

                Text(activity.description)
                    .foregroundStyle(.secondary)

                Divider()

                Label("Points: \(activity.points)", systemImage: "star.fill")

                Label("Completed by \(activity.completedCount) people", systemImage: "person.2.fill")

                Divider()

                Text("Requirements")
                    .font(.title2)
                    .bold()

                Text(activity.requirement)

                Spacer(minLength: 30)

                PhotosPicker(selection: $selectedPhoto, matching: .images) {
                    Label("Complete Activity", systemImage: "camera")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .onChange(of: selectedPhoto) { _, newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self),
                           let uiImage = UIImage(data: data) {
                            selectedImage = Image(uiImage: uiImage)
                            imageData = data
                            showSubmitButton = true
                        }
                    }
                }

                if let selectedImage {
                    Divider()

                    Text("Proof Photo")
                        .font(.headline)

                    selectedImage
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                
                if showSubmitButton {
                    Button("Submit") {
                        uploadPhoto()
                    }
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity)
                }
            }
            .padding()
        }
            if showSuccess {
                Color.black.opacity(0.35)
                    .ignoresSafeArea()

                VStack(spacing: 16) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 90))
                        .foregroundStyle(.green)
                        .scaleEffect(animateSuccess ? 1 : 0.5)

                    Text("Activity Submitted!")
                        .font(.title2)
                        .bold()
                }
                .padding(30)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 24))
            }
        }
        .navigationTitle("Activity")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func uploadPhoto() {
        guard let imageData else { return }
        print("Starting upload...")
        guard let uid = Auth.auth().currentUser?.uid else {
            print("No authenticated user.")
            print("User not signed in")
            return
        }

        let ref = Storage.storage()
            .reference()
            .child("activityProofs")
            .child(uid)
            .child("\(activity.id).jpg")

        ref.putData(imageData, metadata: nil) { _, error in
            if let error = error {
                print(error)
                print("Upload failed: \(error.localizedDescription)")
                return
            }

            ref.downloadURL { url, error in
                if let error = error {
                    print("Couldn't get download URL: \(error.localizedDescription)")
                    return
                }

                if let url {
                    DispatchQueue.main.async {
                        print("Photo uploaded successfully: \(url.absoluteString)")
                        showSubmitButton = false
                        withAnimation(.spring()) {
                            animateSuccess = true
                            showSuccess = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                            dismiss()
                        }
                    }
                }
            }
        }
    }
}
