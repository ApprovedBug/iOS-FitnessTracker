//
//  MealItemViewModel.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 17/11/2023.
//

import DependencyManagement
@preconcurrency import FitnessPersistence
import Foundation

@Observable
@MainActor
class MealEntryHeaderViewModel: Identifiable {
    
    struct EventHandler {
        let saveMealTapped: () -> Void
    }
    
    private(set) var mealTitle: String = ""
    private(set) var kcalConsumed: String = ""
    private(set) var proteinsConsumed: String = ""
    private(set) var fatsConsumed: String = ""
    private(set)var carbsConsumed: String = ""

    @ObservationIgnored
    private var entries: [DiaryEntry] = []
    
    @ObservationIgnored
    let mealType: MealType
    
    @ObservationIgnored
    var eventHandler: EventHandler?
    
    // MARK: Initialisers
    
    init(
        mealType: MealType,
        entries: [DiaryEntry],
        eventHandler: EventHandler?
    ) {
        self.mealType = mealType
        self.entries = entries
        self.eventHandler = eventHandler
        
        populateUI()
    }
    
    // MARK: Public functions
    
    func addEntry(entry: DiaryEntry) {
        entries.append(entry)
        
        populateUI()
    }
    
    func saveMealTapped() async {
        eventHandler?.saveMealTapped()
    }
    
    // MARK: Private functions
    
    private func populateUI() {
        
        var kcalConsumed: Int = 0
        var proteinsConsumed: Double = 0
        var fatsConsumed: Double = 0
        var carbsConsumed: Double = 0
        
        for entry in entries {
            kcalConsumed += entry.totalCalories
            proteinsConsumed += entry.totalProtein
            fatsConsumed += entry.totalFat
            carbsConsumed += entry.totalCarbs
        }
        
        mealTitle = NSLocalizedString("meal_\(mealType)", comment: "Meal title")
        self.kcalConsumed = String(kcalConsumed)
        self.proteinsConsumed = String(format: "%.1f", proteinsConsumed)
        self.fatsConsumed = String(format: "%.1f", fatsConsumed)
        self.carbsConsumed = String(format: "%.1f", carbsConsumed)
    }
}
