//
//  MealsViewModel.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 22/10/2023.
//

import Foundation

@Observable
class MealsViewModel {

    enum State {
        case idle
        case ready(items: [MealItemViewModel])
    }
    
    // MARK: Published properties
    
    var state: State = .idle
    
    // MARK: Initialisers
    
    init(entries: [DiaryEntry]) {
        
        populateUI(entries: entries)
    }
    
    // MARK: Private functions
    
    private func populateUI(entries: [DiaryEntry]) {
        
        var meals: [MealItemViewModel] = []
        
        for entry in entries {
            
            if let meal = meals.first(where: { vm in
                vm.meal == entry.meal
            }) {
                meal.addEntry(entry: entry)
            } else {
                meals.append(MealItemViewModel(meal: entry.meal, entries: [entry]))
            }
        }
        
        state = .ready(items: meals)
    }
}
