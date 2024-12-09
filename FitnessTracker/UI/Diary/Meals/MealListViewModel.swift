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
        let addEntryTapped: (MealType) -> Void
        let removeEntryTapped: (DiaryEntry) -> Void
        let editEntryTapped: (DiaryEntry) -> Void
        let saveMealTapped: ([DiaryEntry]) -> Void
    }
    
    // MARK: Private properties
    
    private(set) var eventHandler: EventHandler?
    var currentMeals: [ItemViewModel] = []
    
    // MARK: Initialisers
    
    @MainActor
    init(entries: [DiaryEntry]) {
        updateEntries(entries: entries)
    }
    
    // MARK: Public functions
    
    @MainActor
    func updateEntries(entries: [DiaryEntry]) {
        
        var meals: [ItemViewModel] = []
        
        MealType.allCases.forEach { mealType in
            
            let mealEntries: [DiaryEntry] = entries.filter { entry in
                mealType == entry.mealType
            }
            
            let entryViewModels: [MealEntryViewModel] = entries.filter { entry in
                mealType == entry.mealType
            }.map { entry in
                MealEntryViewModel(diaryEntry: entry)
            }
            
            let headerViewModel = MealEntryHeaderViewModel(
                mealType: mealType,
                entries: mealEntries,
                eventHandler: MealEntryHeaderViewModel.EventHandler(
                    saveMealTapped: { [weak self] in
                        self?.eventHandler?.saveMealTapped(mealEntries)
                    }
                )
            )
            
            let vm = ItemViewModel(
                mealType: mealType,
                headerViewModel: headerViewModel,
                entryViewModels: entryViewModels
            )
            
            meals.append(vm)
        }
        
        currentMeals = meals
    }
    
    func setEventHandler(eventHandler: EventHandler) {
        self.eventHandler = eventHandler
    }
    
    @MainActor
    func addEntryTapped(mealType: MealType) {
        eventHandler?.addEntryTapped(mealType)
    }
    
    @MainActor
    func deleteEntryTapped(entry: MealEntryViewModel) {
        eventHandler?.removeEntryTapped(entry.diaryEntry)
    }
    
    @MainActor
    func editEntryTapped(entry: MealEntryViewModel) {
        eventHandler?.editEntryTapped(entry.diaryEntry)
    }
    
    class ItemViewModel: Identifiable {
        let mealType: MealType
        let headerViewModel: MealEntryHeaderViewModel
        let entryViewModels: [MealEntryViewModel]
        
        init(
            mealType: MealType,
            headerViewModel: MealEntryHeaderViewModel,
            entryViewModels: [MealEntryViewModel]
        ) {
            self.mealType = mealType
            self.headerViewModel = headerViewModel
            self.entryViewModels = entryViewModels
        }
    }
}
