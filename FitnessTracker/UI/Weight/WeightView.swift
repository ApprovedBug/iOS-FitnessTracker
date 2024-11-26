//
//  WeightView.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 22/10/2023.
//

import Charts
import DependencyManagement
import FitnessPersistence
import FitnessUI
import Foundation
import SwiftUI

struct WeightView: View {
    
    let viewModel: WeightViewModel
    
    var body: some View {
        contentView()
            .onAppear {
                Task {
                    await viewModel.loadData()
                }
            }
    }
    
    @ViewBuilder
    func contentView() -> some View {
        VStack {
            Chart {
                ForEach(viewModel.lineMarkData, id: \.date) { entry in
                    LineMark(
                        x: .value("Day", entry.date, unit: .day),
                        y: .value("Weight", entry.weight)
                    )
                    .symbol(Circle().strokeBorder(lineWidth: 2))
                    .interpolationMethod(.catmullRom)
                }
            }
            .chartXAxis {
                AxisMarks(values: viewModel.weeklyMarkers) { date in
                    AxisValueLabel {
                        if let date = date.as(Date.self) {
                            Text(date, format: Date.FormatStyle().day().month(.twoDigits))
                        } else {
                            Text("") // Fallback for invalid values
                        }
                    }
                }
            }
            .chartYScale(domain: viewModel.yAxisRange)
            .chartLegend(.hidden)
            .frame(maxHeight: 200)
            .padding()
            
            Spacer()
        }
    }
}

#Preview {
    
    DependencyContainer.register(WeightRepository.self) {
        MockWeightRepository()
    }
    
    let viewModel = WeightViewModel()
    Task {
        await viewModel.loadData()
    }
    return NavigationStack {
        WeightView(viewModel: viewModel)
            .navigationTitle("Weight")
        }
}

private class MockWeightRepository: WeightRepository {
    
    private var entries: [WeightEntry] = []
    
    init() {
        self.entries = [
            WeightEntry(date: Calendar.current.date(byAdding: .day, value: -20, to: Date())!, weight: 82.5),
            WeightEntry(date: Calendar.current.date(byAdding: .day, value: -18, to: Date())!, weight: 82),
            WeightEntry(date: Calendar.current.date(byAdding: .day, value: -16, to: Date())!, weight: 81.7),
            WeightEntry(date: Calendar.current.date(byAdding: .day, value: -11, to: Date())!, weight: 81.9),
            WeightEntry(date: Calendar.current.date(byAdding: .day, value: -7, to: Date())!, weight: 80.8),
            WeightEntry(date: Calendar.current.date(byAdding: .day, value: -5, to: Date())!, weight: 80.3),
            WeightEntry(date: Calendar.current.date(byAdding: .day, value: -4, to: Date())!, weight: 79.7),
            WeightEntry(date: Calendar.current.date(byAdding: .day, value: -3, to: Date())!, weight: 80.2),
            WeightEntry(date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!, weight: 79.6),
            WeightEntry(date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, weight: 79.4),
            WeightEntry(date: Date(), weight: 79),
        ]
    }
    
    @MainActor func save(entry: WeightEntry) {
        entries.append(entry)
    }
    
    @MainActor func allEntries() -> [WeightEntry] {
        entries
    }
}
