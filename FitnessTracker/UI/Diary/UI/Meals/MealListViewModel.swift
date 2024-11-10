//
//  MealsViewModel.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 22/10/2023.
//

import FitnessPersistence
import Foundation

@Observable
class MealListViewModel {
    
    struct EventHandler {
        let diaryEntryAdded: (DiaryEntry) -> Void
        let diaryEntryRemoved: (DiaryEntry) -> Void
        let diaryEntryUpdated: (DiaryEntry) -> Void
    }

    enum State {
        case idle
        case ready(items: [MealListItemViewModel])
    }
    
    // MARK: Published properties
    
    var state: State = .idle
    var isAddDiaryEntryOpen: Bool = false
    var addDiaryEntryViewModel: AddDiaryEntryViewModel?
    
    // MARK: Private properties
    
    private(set) var eventHandler: EventHandler?
    private(set) var currentlySelectedDate: Date
    private var currentMeals: [MealListItemViewModel] = []
    
    // MARK: Initialisers
    
    init(currentlySelectedDate: Date) {
        self.currentlySelectedDate = currentlySelectedDate
    }
    
    // MARK: Public functions
    
    @MainActor func updateEntries(entries: [DiaryEntry]) {
        
        let addDiaryEntryEventHandler = AddDiaryEntryViewModel.EventHandler(
            diaryEntryAdded: { [weak self] entry in
            // new entry added
            guard let self else { return }
            currentMeals.first(where: { $0.mealType == entry.mealType })?.addEntry(entry: entry)
            eventHandler?.diaryEntryAdded(entry)
            }) { [weak self] entries in
                // new meal added
                guard let self else { return }
                let meal = currentMeals.first(where: { $0.mealType == entries.first?.mealType })
                entries.forEach { entry in
                    meal?.addEntry(entry: entry)
                    eventHandler?.diaryEntryAdded(entry)
                }
            }
        
        let itemEventHandler = MealListItemViewModel.EventHandler(
            openAddDiaryEntryTapped: { [weak self] mealType in
            // add new entry opened
            guard let self else { return }
            addDiaryEntryViewModel = AddDiaryEntryViewModel(
                date: currentlySelectedDate,
                mealType: mealType,
                eventHandler: addDiaryEntryEventHandler
            )
            isAddDiaryEntryOpen = true
        }, diaryEntryRemoved: { [weak self] entry in
            // entry removed
            guard let self else { return }
            eventHandler?.diaryEntryRemoved(entry)
        }, diaryEntryUpdated: { [weak self] entry in
            // entry updated
            guard let self else { return }
            eventHandler?.diaryEntryUpdated(entry)
        })
        
        let meals: [MealListItemViewModel] = MealType.allCases.map {
            MealListItemViewModel(
                mealType: $0,
                entries: [],
                eventHandler: itemEventHandler
            )
        }
        
        for entry in entries {
            
            if let meal = meals.first(where: { vm in
                vm.mealType == entry.mealType
            }) {
                meal.addEntry(entry: entry)
            }
        }
        currentMeals = meals
        state = .ready(items: meals)
    }
    
    func setEventHandler(eventHandler: EventHandler) {
        self.eventHandler = eventHandler
    }
    
    func updateCurrentlySelectedDate(to date: Date) {
        currentlySelectedDate = date
    }
}
