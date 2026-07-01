import SwiftUI

struct RankBadge: View {
    let points: Int

    var rank: String {
        if points >= 5000 { return "🏆 Legendary Wanderer" }
        if points >= 1000 { return "🥇 SideQuest Master" }
        if points >= 500 { return "🥈 Adventurer" }
        if points >= 100 { return "🥉 Bronze Explorer" }
        return "🌱 New Explorer"
    }

    var body: some View {
        Text(rank)
            .font(.headline)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(.thinMaterial)
            .clipShape(Capsule())
    }
}
