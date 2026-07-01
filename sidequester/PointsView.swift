import SwiftUI

struct PointsView: View {
    let userPoints: Int

    var body: some View {
        VStack(spacing: 30) {

            Text("\(userPoints)")
                .font(.system(size: 70, weight: .bold))

            Text("Explorer Points")
                .font(.title2)

            RankBadge(points: userPoints)

            Spacer()
        }
        .padding()
    }
}
