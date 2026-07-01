
import SwiftUI

struct ActivitySearchView: View {
    let activities: [Activity]

    @State private var searchText = ""
    @State private var showingAddSheet = false

    @State private var selectedAge = "Any"
    @State private var selectedEffort = "Any"
    @State private var selectedTime = "Any"
    @State private var selectedCost = "Any"
    @State private var selectedShelter = "Any"

    let ageOptions = ["Any", "Kids", "Teens", "Adults", "Seniors"]
    let effortOptions = ["Any", "Low", "Moderate", "High"]
    let timeOptions = ["Any", "<15 mins", "15-30 mins", "30-60 mins", "1 hour+"]
    let costOptions = ["Any", "Free", "$", "$$", "$$$"]
    let shelterOptions = ["Any", "Indoor", "Outdoor", "Both"]

    var filteredActivities: [Activity] {
        activities.filter { activity in
            (searchText.isEmpty || activity.name.localizedCaseInsensitiveContains(searchText)) &&
            (selectedAge == "Any" || activity.age == selectedAge) &&
            (selectedEffort == "Any" || activity.physical == selectedEffort) &&
            (selectedTime == "Any" || activity.time == selectedTime) &&
            (selectedCost == "Any" || activity.cost == selectedCost) &&
            (selectedShelter == "Any" || activity.shelter == selectedShelter)
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    HStack {
                        TextField("Search activities...", text: $searchText)
                            .textFieldStyle(.roundedBorder)

                        Button {
                            showingAddSheet = true
                        } label: {
                            Image(systemName: "plus")
                                .font(.title2)
                        }
                    }

                    Group {
                        Text("Age Range")
                            .font(.headline)
                        Picker("Age Range", selection: $selectedAge) {
                            ForEach(ageOptions, id: \.self) { Text($0) }
                        }
                        .pickerStyle(.menu)

                        Text("Effort Level")
                            .font(.headline)
                        Picker("Effort Level", selection: $selectedEffort) {
                            ForEach(effortOptions, id: \.self) { Text($0) }
                        }
                        .pickerStyle(.menu)

                        Text("Time Required")
                            .font(.headline)
                        Picker("Time Required", selection: $selectedTime) {
                            ForEach(timeOptions, id: \.self) { Text($0) }
                        }
                        .pickerStyle(.menu)

                        Text("Cost")
                            .font(.headline)
                        Picker("Cost", selection: $selectedCost) {
                            ForEach(costOptions, id: \.self) { Text($0) }
                        }
                        .pickerStyle(.menu)

                        Text("Shelter")
                            .font(.headline)
                        Picker("Shelter", selection: $selectedShelter) {
                            ForEach(shelterOptions, id: \.self) { Text($0) }
                        }
                        .pickerStyle(.menu)
                    }

                    ForEach(filteredActivities) { activity in
                        ActivityCard(activity: activity)
                    }
                }
                .padding()
            }
            .navigationTitle("Activities")
            .sheet(isPresented: $showingAddSheet) {
                AddActivityView()
            }
        }
    }
}

struct AddActivityView: View {
    var body: some View {
        NavigationStack {
            Text("Add Activity Coming Soon")
                .font(.title2)
                .navigationTitle("New Activity")
        }
    }
}
