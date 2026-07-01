//
//  ContentView.swift
//  TARDIS
//
//  Created by Rayson Ng on 29/6/26.
//

import SwiftUI
import SwiftData
import FirebaseFirestore

struct ContentView: View {
    @State private var suggestedActivity = "Press Generate Activity to begin!"
    @State private var activities: [String] = [
        "Take a nature walk and photograph five interesting things you find.",
        "Visit a local library and choose a random book to read for 20 minutes.",
        "Learn to fold an origami crane using paper you have at home.",
        "Try sketching an object on your desk for 10 minutes.",
        "Cook a simple snack or meal you've never made before.",
        "Play a board game or card game with someone nearby.",
        "Spend 15 minutes learning basic phrases in a new language.",
        "Explore a nearby park and identify three different plants or animals.",
        "Write a short story using only 100 words.",
        "Build something creative using household items."
    ]
    @State private var newActivity = ""

    let db = Firestore.firestore()

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("SideQuester")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Discover something new away from endless scrolling")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal)

                VStack(spacing: 12) {
                    Label("Low Energy", systemImage: "battery.25")
                    Label("30 Minutes Free", systemImage: "clock")
                    Label("2-4 People", systemImage: "person.3")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(.gray.opacity(0.1))
                .cornerRadius(16)
                .padding(.horizontal)

                Button("Generate Activity") {
                    suggestedActivity = activities.randomElement() ?? "No activities available"
                }
                .buttonStyle(.borderedProminent)

                VStack(alignment: .leading, spacing: 10) {
                    Text("Suggested Activity")
                        .font(.headline)

                    Text(suggestedActivity)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(.green.opacity(0.15))
                        .cornerRadius(16)
                }
                .padding(.horizontal)

                Divider()

                TextField("Add a new activity", text: $newActivity)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)

                Button("Add Activity") {
                    guard !newActivity.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                        return
                    }

                    db.collection("activities").addDocument(data: [
                        "name": newActivity,
                        "createdAt": Timestamp(date: Date())
                    ]) { error in
                        if let error = error {
                            print("Failed to save activity: \(error.localizedDescription)")
                        }
                    }

                    newActivity = ""
                }
                .buttonStyle(.borderedProminent)

                List(activities, id: \.self) { activity in
                    Text(activity)
                }
                .frame(height: 200)

                Spacer()
            }
            .padding()
            .navigationTitle("SideQuester")
        }
        .onAppear {
            db.collection("activities")
                .order(by: "createdAt")
                .addSnapshotListener { snapshot, error in
                    if let error = error {
                        print("Firestore error: \(error.localizedDescription)")
                        return
                    }

                    guard let documents = snapshot?.documents else {
                        return
                    }

                    activities = [
                        "Take a nature walk and photograph five interesting things you find.",
                        "Visit a local library and choose a random book to read for 20 minutes.",
                        "Learn to fold an origami crane using paper you have at home.",
                        "Try sketching an object on your desk for 10 minutes.",
                        "Cook a simple snack or meal you've never made before.",
                        "Play a board game or card game with someone nearby.",
                        "Spend 15 minutes learning basic phrases in a new language.",
                        "Explore a nearby park and identify three different plants or animals.",
                        "Write a short story using only 100 words.",
                        "Build something creative using household items."
                    ]

                    for document in documents {
                        if let name = document.data()["name"] as? String,
                           !activities.contains(name) {
                            activities.append(name)
                        }
                    }
                }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
