import SwiftUI

struct ActivityCard: View {
    let activity: Activity

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(activity.name)
                .font(.headline)

            HStack {
                Label("\(activity.points) pts", systemImage: "star.fill")
                Label(activity.time, systemImage: "clock")
                Label(activity.cost, systemImage: "dollarsign.circle")
            }
            .font(.caption)
            .foregroundStyle(.secondary)

            HStack {
                Text(activity.physical)
                Text("•")
                Text(activity.shelter)
            }
            .font(.caption2)
            .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.green.opacity(0.15))
        .cornerRadius(16)
    }
}
