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
        let filtered = activities.filter {
            $0.name != "Firebase connection successful 🎉"
        }

        return Array(filtered.shuffled().prefix(3))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                Text("Welcome back 👋")
                    .font(.largeTitle.bold())

                Text("Recommended For You")
                    .font(.title2.bold())

                ForEach(recommendations) { activity in
                    ActivityCard(activity: activity)
                }

                Text("🔥 Trending")
                    .font(.title2.bold())

                ForEach(trendingActivities) { activity in
                    ActivityCard(activity: activity)
                }
            }
            .padding()
        }
    }
}
