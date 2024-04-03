//
//  SummaryViewModel.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 22/10/2023.
//

import FitnessPersistence
import Foundation
    
@Observable
class SummaryViewModel {
    
    struct Data {
        let kcalConsumed: String
        let kcalBurned: String
        let kcalProgress: Double
        let kcalRemaining: String
        let proteinsConsumed: String
        let fatsConsumed: String
        let carbsConsumed: String
    }
    
    enum State {
        case idle
        case ready(Data)
    }
    
    // MARK: Published properties
    
    var state: State = .idle
    
    // MARK: Initialisers
    
    init(entries: [DiaryEntry]) {
        
        populateUI(entries: entries)
    }
    
    // MARK: Private functions
    
    private func populateUI(entries: [DiaryEntry]) {
        
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
                kcalConsumed: String(Int(kcalConsumed)),
                kcalBurned: "0",
                kcalProgress: 0.64,
                kcalRemaining: "900",
                proteinsConsumed: String(Int(proteinsConsumed)),
                fatsConsumed: String(Int(fatsConsumed)),
                carbsConsumed: String(Int(carbsConsumed))
            )
        )
    }
}
