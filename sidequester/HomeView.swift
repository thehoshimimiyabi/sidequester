import SwiftUI

struct HomeView: View {
    let activities: [Activity]

    var recommendations: [Activity] {
        let filtered = activities.filter {
            $0.name != "Firebase connection successful 🎉"
        }

        return Array(filtered.shuffled().prefix(3))
    }

    var trendingActivities: [Activity] {
        activities
            .filter { $0.name != "Firebase connection successful 🎉" }
            .sorted { $0.points > $1.points }
            .prefix(5)
            .map { $0 }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    Text("Welcome back 👋")
                        .font(.largeTitle.bold())

                    Text("Recommended For You")
                        .font(.title2.bold())

                    ForEach(recommendations) { activity in
                        NavigationLink(destination: ActivityDetailView(activity: activity)) {
                            ActivityCard(activity: activity)
                        }
                        .buttonStyle(.plain)
                    }

                    Text("🔥 Trending")
                        .font(.title2.bold())

                    ForEach(trendingActivities) { activity in
                        NavigationLink(destination: ActivityDetailView(activity: activity)) {
                            ActivityCard(activity: activity)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }
        }
    }
}
