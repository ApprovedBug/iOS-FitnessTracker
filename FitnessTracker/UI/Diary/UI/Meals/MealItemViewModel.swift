//
//  MealItemViewModel.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 17/11/2023.
//

import Foundation

@Observable
class MealItemViewModel: Identifiable {
    
    enum State {
        case idle
        case ready(Data)
    }
    
    struct Data {
        let mealTitle: String
        let kcalConsumed: String
        let proteinsConsumed: String
        let fatsConsumed: String
        let carbsConsumed: String
    }
    
    var state: State = .idle
    
    private var entries: [DiaryEntry] = []
    
    let meal: Meal
    
    // MARK: Initialisers
    
    init(meal: Meal, entries: [DiaryEntry]) {
        
        self.meal = meal
        self.entries = entries
        
        populateUI()
    }
    
    // MARK: Public functions
    
    func addEntry(entry: DiaryEntry) {
        entries.append(entry)
        
        populateUI()
    }
    
    // MARK: Private functions
    
    private func populateUI() {
        
        var kcalConsumed: Double = 0
        var proteinsConsumed: Double = 0
        var fatsConsumed: Double = 0
        var carbsConsumed: Double = 0
        
        for entry in entries {
            kcalConsumed += entry.foodItem.kcal
            proteinsConsumed += entry.foodItem.protein
            fatsConsumed += entry.foodItem.fats
            carbsConsumed += entry.foodItem.carbs
        }
        
        state = .ready(
            .init(
                mealTitle: "Add \(meal)",
                kcalConsumed: String(Int(kcalConsumed)),
                proteinsConsumed: String(Int(proteinsConsumed)),
                fatsConsumed: String(Int(fatsConsumed)),
                carbsConsumed: String(Int(carbsConsumed))
            )
        )
    }
}
