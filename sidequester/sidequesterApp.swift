//
//  TARDISApp.swift
//  TARDIS
//
//  Created by Rayson Ng on 29/6/26.
//

import SwiftUI
import SwiftData
import FirebaseCore
import FirebaseFirestore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()

        let db = Firestore.firestore()

        // Test Firestore connection on launch
        db.collection("activities").addDocument(data: [
            "name": "Firebase connection successful 🎉",
            "createdAt": Timestamp(date: Date())
        ]) { error in
            if let error = error {
                print("Firestore write failed: \(error.localizedDescription)")
            } else {
                print("Firestore write succeeded!")
            }
        }

        return true
    }
}

@main
struct sidequesterApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }
        .modelContainer(sharedModelContainer)
    }
}
