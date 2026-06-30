//
//  ContentView.swift
//  TARDIS
//
//  Created by Rayson Ng on 29/6/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("TARDIS")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Discover something new away from endless scrolling")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal)

                VStack(spacing: 12) {
                    Label("Low Energy", systemImage: "battery.25")
                    Label("30 Minutes Free", systemImage: "clock")
                    Label("2-4 People", systemImage: "person.3")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(.gray.opacity(0.1))
                .cornerRadius(16)
                .padding(.horizontal)

                Button("Generate Activity") {
                }
                .buttonStyle(.borderedProminent)

                VStack(alignment: .leading, spacing: 10) {
                    Text("Suggested Activity")
                        .font(.headline)

                    Text("Try a nature walk at a nearby park and take photos of five interesting things you spot.")
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(.green.opacity(0.15))
                        .cornerRadius(16)
                }
                .padding(.horizontal)

                Spacer()
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
