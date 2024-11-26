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
        allWeightEntries = weightRepository.allEntries()
        
        // Generate the complete weight data for the last 30 days
        prepareChartData(from: allWeightEntries)
        
        if let mostRecentEntry = allWeightEntries.last {
            self.currentWeight = mostRecentEntry.weight
        }
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
    
    func addWeightTapped() {
        isShowingAddWeightSheet = true
    }
    
    @MainActor func saveWeight(weight: Double) {
        let weightEntry = WeightEntry(date: Date(), weight: weight)
        weightRepository.save(entry: weightEntry)
        
        allWeightEntries.append(weightEntry)
        prepareChartData(from: allWeightEntries)
    }
}
