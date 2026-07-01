import SwiftUI

struct AchievementsView: View {
    let userPoints: Int

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                AchievementCard(
                    title: "Bronze Explorer",
                    description: "Earn 100 points.",
                    icon: "medal.fill",
                    unlocked: userPoints >= 100
                )

                AchievementCard(
                    title: "Adventurer",
                    description: "Earn 500 points.",
                    icon: "figure.walk",
                    unlocked: userPoints >= 500
                )

                AchievementCard(
                    title: "SideQuest Master",
                    description: "Earn 1000 points.",
                    icon: "star.fill",
                    unlocked: userPoints >= 1000
                )

                AchievementCard(
                    title: "Legendary Wanderer",
                    description: "Earn 5000 points.",
                    icon: "trophy.fill",
                    unlocked: userPoints >= 5000
                )
            }
            .padding()
        }
    }
}
