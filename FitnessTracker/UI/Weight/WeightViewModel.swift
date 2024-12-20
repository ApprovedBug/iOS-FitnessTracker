//
//  WeightViewModel.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 22/10/2023.
//

import DependencyManagement
@preconcurrency import FitnessPersistence
import Foundation

@Observable
class WeightViewModel {
    
    var allWeightEntries: [WeightEntry] = []
    var lineMarkData: [WeightEntry] = []
    var weeklyMarkers: [Date] = []
    var yAxisRange: ClosedRange<Double> = 30...150
    var isShowingAddWeightSheet: Bool = false
    var currentWeight: Double = 75
    
    @ObservationIgnored
    @Inject var weightRepository: WeightRepository
    
    init() {
        
    }
    
    @MainActor
    func loadData() async {
        // Fetch the weight entries from the repository
        allWeightEntries = weightRepository.all().reversed()
        
        // Generate the complete weight data for the last 30 days
        prepareChartData(from: allWeightEntries)
        
        updateCurrentWeight()
    }

    private func prepareChartData(from fetchedData: [WeightEntry]) {
        let calendar = Calendar.current

        // Find the earliest date in the data
        let earliestDate = fetchedData.min(by: { $0.date < $1.date })?.date ?? Date()

        // Start the x-axis from the beginning of the earliest date
        let startDate = calendar.startOfDay(for: earliestDate)

        // Extend the range to 30 days from the startDate
        let xAxisDates = (0..<30).compactMap {
            calendar.date(byAdding: .day, value: $0, to: startDate)
        }
        
        // Determine the start of each week
        weeklyMarkers = xAxisDates.filter { date in
            calendar.component(.weekday, from: date) == calendar.firstWeekday
        }

        // Populate lineMarkData with only the dates that have weights
        lineMarkData = fetchedData.filter { entry in
            xAxisDates.contains(calendar.startOfDay(for: entry.date))
        }
        
        calculateYAxisRange()
    }
    
    private func calculateYAxisRange() {
        guard let minWeight = lineMarkData.map(\.weight).min(),
              let maxWeight = lineMarkData.map(\.weight).max() else {
            return
        }

        let padding: Double = 5
        yAxisRange = (minWeight - padding)...(maxWeight + padding)
    }
    
    private func updateCurrentWeight() {
        if let mostRecentEntry = allWeightEntries.first {
            self.currentWeight = mostRecentEntry.weight
        }
    }
    
    func addWeightTapped() {
        isShowingAddWeightSheet = true
    }
    
    @MainActor
    func saveWeight(weight: Double, date: Date) {
        // Check if an entry already exists for the same date
        if let existingEntryIndex = allWeightEntries.firstIndex(where: { Calendar.current.isDate($0.date, inSameDayAs: date) }) {
            // If an entry exists for the same date, update its weight
            allWeightEntries[existingEntryIndex].weight = weight
        } else {
            // Otherwise, create a new entry and insert it
            let weightEntry = WeightEntry(date: date, weight: weight)
            allWeightEntries.append(weightEntry)
            weightRepository.save(entry: weightEntry)
        }

        // Sort entries by date in descending order (most recent first)
        allWeightEntries.sort { $0.date > $1.date }
        
        // Prepare chart data with the updated list
        prepareChartData(from: allWeightEntries)
        
        // Update the current weight (if needed, based on your logic)
        updateCurrentWeight()
    }
    
    @MainActor func removeEntry(at offsets: IndexSet) {
        
        for index in offsets {
            let entryToDelete = allWeightEntries[index]
            weightRepository.remove(entry: entryToDelete)
        }
        
        allWeightEntries.remove(atOffsets: offsets)
        prepareChartData(from: allWeightEntries)
        updateCurrentWeight()
    }
}
