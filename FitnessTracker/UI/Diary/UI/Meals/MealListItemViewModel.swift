//
//  MealItemViewModel.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 17/11/2023.
//

import DependencyManagement
import FitnessPersistence
import Foundation

@Observable
class MealListItemViewModel: Identifiable {

    struct EventHandler {
        let addDiaryEntryTapped: (Meal) -> Void
        let diaryEntryRemoved: (DiaryEntry) -> Void
    }
    
    enum State {
        case idle
        case ready(Data)
    }
    
    struct Data {
        let mealTitle: String
        let entries: [DiaryEntry]
        let kcalConsumed: String
        let proteinsConsumed: String
        let fatsConsumed: String
        let carbsConsumed: String
    }
    
    var state: State = .idle

    private var entries: [DiaryEntry] = []
    
    @ObservationIgnored
    let meal: Meal
    
    @ObservationIgnored
    let eventHandler: EventHandler?
    
    @ObservationIgnored
    @Inject
    var diaryRepository: DiaryRepository
    
    // MARK: Initialisers
    
    init(
        meal: Meal,
        entries: [DiaryEntry],
        eventHandler: MealListItemViewModel.EventHandler? = nil
    ) {
        
        self.meal = meal
        self.entries = entries
        self.eventHandler = eventHandler
        
        populateUI()
    }
    
    // MARK: Public functions
    
    func addEntry(entry: DiaryEntry) {
        entries.append(entry)
        
        populateUI()
    }
    
    func addEntryTapped() {
        eventHandler?.addDiaryEntryTapped(meal)
    }
    
    func removeEntry(diaryEntry: DiaryEntry) {
        diaryRepository.removeDiaryEntry(diaryEntry: diaryEntry)
        eventHandler?.diaryEntryRemoved(diaryEntry)
        entries.removeAll(where: { $0.id == diaryEntry.id })
        populateUI()
    }
    
    // MARK: Private functions
    
    private func populateUI() {
        
        var kcalConsumed: Int = 0
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
                mealTitle: NSLocalizedString("meal_\(meal)", comment: "Meal title"),
                entries: entries,
                kcalConsumed: String(Int(kcalConsumed)),
                proteinsConsumed: String(Int(proteinsConsumed)),
                fatsConsumed: String(Int(fatsConsumed)),
                carbsConsumed: String(Int(carbsConsumed))
            )
        )
    }
}
