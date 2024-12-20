//
//  SummaryViewModel.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 22/10/2023.
//

import DependencyManagement
import FitnessPersistence
import Foundation
    
@Observable
class SummaryViewModel {
    
    struct Data {
        let kcalConsumed: String
        let kcalProgress: Double
        let kcalRemaining: String
        let carbsViewModel: MacrosViewModel
        let proteinViewModel: MacrosViewModel
        let fatsViewModel: MacrosViewModel
    }
    
    // MARK: Published properties
    
    var data: Data?
    
    // MARK: Private properties
    
    @ObservationIgnored
    private let goals: Goals
    
    // MARK: Initialisers
    
    init(goals: Goals, entries: [DiaryEntry] = []) {
        self.goals = goals
        
        process(goals: goals, entries: entries)
    }
    
    func updateEntries(with entries: [DiaryEntry]) {
        process(goals: goals, entries: entries)
    }

    // MARK: - Helper functions
    
    private func process(goals: Goals, entries: [DiaryEntry]) {
        
        // Calculate consumed values based on entries
        let (kcalConsumed, carbsConsumed, proteinsConsumed, fatsConsumed) = calculateConsumedValues(from: entries)
        
        // Create the view models
        let carbsViewModel = createMacrosViewModel(consumed: carbsConsumed, target: goals.carbs, title: "carbs")
        let proteinsViewModel = createMacrosViewModel(consumed: proteinsConsumed, target: goals.protein, title: "protein")
        let fatsViewModel = createMacrosViewModel(consumed: fatsConsumed, target: goals.fats, title: "fat")
        
        data = .init(
            kcalConsumed: String(kcalConsumed),
            kcalProgress: Double(kcalConsumed) / Double(goals.kcal),
            kcalRemaining: String(format: "%.0f", Double(goals.kcal) - Double(kcalConsumed)),
            carbsViewModel: carbsViewModel,
            proteinViewModel: proteinsViewModel,
            fatsViewModel: fatsViewModel
        )
    }

    private func calculateConsumedValues(from entries: [DiaryEntry]) -> (Int, Double, Double, Double) {
        var kcalConsumed = 0
        var carbsConsumed = 0.0
        var proteinsConsumed = 0.0
        var fatsConsumed = 0.0
        
        entries.forEach { entry in
            kcalConsumed += entry.totalCalories
            carbsConsumed += entry.totalCarbs
            proteinsConsumed += entry.totalProtein
            fatsConsumed += entry.totalFat
        }
        
        return (kcalConsumed, carbsConsumed, proteinsConsumed, fatsConsumed)
    }

    private func createMacrosViewModel(consumed: Double, target: Double, title: String) -> MacrosViewModel {
        return MacrosViewModel(
            consumed: consumed,
            target: target,
            title: title
        )
    }
}
