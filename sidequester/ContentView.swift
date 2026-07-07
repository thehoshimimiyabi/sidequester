//
//  ContentView.swift
//  TARDIS
//
//  Created by Rayson Ng on 29/6/26.
//

import SwiftUI
import SwiftData
import FirebaseFirestore

struct Activity: Identifiable, Hashable {
    let id: String
    let name: String
    let age: String
    let physical: String
    let cost: String
    let shelter: String
    let time: String
    let requirement: String
    let points: Int
}

enum AppTab {
    case home
    case points
    case leaderboard
    case achievements
    case search
}

struct ContentView: View {
    @State private var userPoints = 0
    @State private var activities: [Activity] = [
        Activity(id: UUID().uuidString, name: "Go explore the neighbouring block/estate", age: "Any", physical: "Low", cost: "Free", shelter: "Outdoor", time: "15-30 mins", requirement: "None", points: 10),
        Activity(id: UUID().uuidString, name: "Walk along the footpath until you are tired", age: "Any", physical: "Moderate", cost: "Free", shelter: "Outdoor", time: "30-60 mins", requirement: "None", points: 15),
        Activity(id: UUID().uuidString, name: "Buy a meal from the closest coffee shop/hawker", age: "Any", physical: "Low", cost: "$", shelter: "Indoor", time: "15-30 mins", requirement: "None", points: 10),
        Activity(id: UUID().uuidString, name: "Check out the neighbourhood playground", age: "Kids", physical: "Moderate", cost: "Free", shelter: "Outdoor", time: "15-30 mins", requirement: "None", points: 15),
        Activity(id: UUID().uuidString, name: "Visit your childhood playground", age: "Teens", physical: "Low", cost: "Free", shelter: "Outdoor", time: "15-30 mins", requirement: "None", points: 20),
        Activity(id: UUID().uuidString, name: "Explore a neighbouring estate", age: "Any", physical: "Moderate", cost: "Free", shelter: "Outdoor", time: "30-60 mins", requirement: "None", points: 20),
        Activity(id: UUID().uuidString, name: "Walk to the closest mall", age: "Any", physical: "Low", cost: "Free", shelter: "Both", time: "15-30 mins", requirement: "None", points: 15),
        Activity(id: UUID().uuidString, name: "Take the next bus for a random amount of stops and explore the area", age: "Teens", physical: "Moderate", cost: "$", shelter: "Both", time: "1hr+", requirement: "None", points: 30),
        Activity(id: UUID().uuidString, name: "Check out a new shop/supermarket", age: "Any", physical: "Low", cost: "$", shelter: "Indoor", time: "15-30 mins", requirement: "None", points: 10)
    ]
    let db = Firestore.firestore()

    var body: some View {
        NavigationStack {
            TabView {
                HomeView(activities: activities)
                    .tabItem {
                        Label("Home", systemImage: "house.fill")
                    }

                PointsView(userPoints: userPoints)
                    .tabItem {
                        Label("Points", systemImage: "star.fill")
                    }

                LeaderboardView()
                    .tabItem {
                        Label("Friends", systemImage: "person.3.fill")
                    }

                AchievementsView(userPoints: userPoints)
                    .tabItem {
                        Label("Achievements", systemImage: "trophy.fill")
                    }

                ActivitySearchView(activities: activities)
                    .tabItem {
                        Label("Activities", systemImage: "magnifyingglass")
                    }
            }
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

                    // Refresh local activities with the latest data from Firestore.
                    activities.removeAll()

                    for document in documents {
                        let data = document.data()

                        let activity = Activity(
                            id: document.documentID,
                            name: data["name"] as? String ?? "",
                            age: data["age"] as? String ?? "Any",
                            physical: data["physical"] as? String ?? "Low",
                            cost: data["cost"] as? String ?? "Free",
                            shelter: data["shelter"] as? String ?? "Outdoor",
                            time: data["time"] as? String ?? "15-30 mins",
                            requirement: data["requirement"] as? String ?? "None",
                            points: data["points"] as? Int ?? 10
                        )

                        activities.append(activity)
                        // Each document should contain: name, age, physical, cost, shelter, time, requirement, points, createdAt.
                    }
                }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
