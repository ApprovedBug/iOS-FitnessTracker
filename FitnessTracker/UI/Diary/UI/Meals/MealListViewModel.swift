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
    
    func updateEntries(entries: [DiaryEntry]) {
        
        let addDiaryEntryEventHandler = AddDiaryEntryViewModel.EventHandler { [weak self] entry in
            // new entry added
            guard let self else { return }
            currentMeals.first(where: { $0.meal == entry.meal })?.addEntry(entry: entry)
            eventHandler?.diaryEntryAdded(entry)
        }
        
        let itemEventHandler = MealListItemViewModel.EventHandler(
            addDiaryEntryTapped: { [weak self] meal in
            // add new entry opened
            guard let self else { return }
            addDiaryEntryViewModel = AddDiaryEntryViewModel(
                date: currentlySelectedDate,
                meal: meal,
                eventHandler: addDiaryEntryEventHandler
            )
            isAddDiaryEntryOpen = true
        }, diaryEntryRemoved: { [weak self] entry in
            // entry removed
            guard let self else { return }
            eventHandler?.diaryEntryRemoved(entry)
        })
        
        let meals: [MealListItemViewModel] = Meal.allCases.map {
            MealListItemViewModel(
                meal: $0,
                entries: [],
                eventHandler: itemEventHandler
            )
        }
        
        for entry in entries {
            
            if let meal = meals.first(where: { vm in
                vm.meal == entry.meal
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
