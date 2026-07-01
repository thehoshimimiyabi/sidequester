import SwiftUI

struct LeaderboardView: View {

    let leaderboard = [
        ("Rayson", 1520),
        ("Alex", 1280),
        ("Sarah", 970),
        ("You", 830),
        ("Ryan", 600)
    ]

    var body: some View {
        NavigationStack {
            List {
                ForEach(leaderboard.indices, id: \.self) { index in
                    HStack {
                        Text("#\(index + 1)")

                        Text(leaderboard[index].0)

                        Spacer()

                        Text("\(leaderboard[index].1)")
                            .bold()
                    }
                }
            }
            .navigationTitle("Leaderboard")
        }
    }
}
