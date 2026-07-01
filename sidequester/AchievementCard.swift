import SwiftUI

struct AchievementCard: View {
    let title: String
    let description: String
    let icon: String
    let unlocked: Bool

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: unlocked ? icon : "lock.fill")
                .font(.system(size: 30))

            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)

                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            if unlocked {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.green)
            }
        }
        .padding()
        .background(unlocked ? .green.opacity(0.15) : .gray.opacity(0.1))
        .cornerRadius(16)
    }
}
