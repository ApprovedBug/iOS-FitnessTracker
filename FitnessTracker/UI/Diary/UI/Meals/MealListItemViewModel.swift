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
        let diaryEntryUpdated: (DiaryEntry) -> Void
    }
    
    enum State {
        case idle
        case ready(Data)
    }
    
    struct Data {
        let mealTitle: String
        let entries: [MealEntryViewModel]
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
    
    func updateEntry(diaryEntry: DiaryEntry, servings: Double) {
        diaryEntry.servings = servings
        eventHandler?.diaryEntryUpdated(diaryEntry)
        populateUI()
    }
    
    // MARK: Private functions
    
    private func populateUI() {
        
        var kcalConsumed: Int = 0
        var proteinsConsumed: Double = 0
        var fatsConsumed: Double = 0
        var carbsConsumed: Double = 0
        
        for entry in entries {
            kcalConsumed += entry.totalCalories
            proteinsConsumed += entry.totalProteins
            fatsConsumed += entry.totalFats
            carbsConsumed += entry.totalCarbs
        }
        
        let mealEntryViewModels: [MealEntryViewModel] = entries.map {
            let eventHandler = MealEntryViewModel.EventHandler { [weak self] entry in
                self?.removeEntry(diaryEntry: entry)
            } updateEntry: { [weak self] entry, servings in
                self?.updateEntry(diaryEntry: entry, servings: servings)
            }

            return MealEntryViewModel(diaryEntry: $0, eventHandler: eventHandler)
        }
        
        state = .ready(
            .init(
                mealTitle: NSLocalizedString("meal_\(meal)", comment: "Meal title"),
                entries: mealEntryViewModels,
                kcalConsumed: String(kcalConsumed),
                proteinsConsumed: String(format: "%.1f", proteinsConsumed),
                fatsConsumed: String(format: "%.1f", fatsConsumed),
                carbsConsumed: String(format: "%.1f", carbsConsumed)
            )
        )
    }
}
