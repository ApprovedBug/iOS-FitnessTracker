//
//  MealEntryViewModel.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 31/10/2024.
//

import FitnessPersistence
import Foundation

@Observable
@MainActor
class MealEntryViewModel: Identifiable {
    
    struct EventHandler {
        let removeEntryTapped: @MainActor (DiaryEntry) async -> Void
        let updateEntry: @MainActor (DiaryEntry, Double) async -> Void
    }
    
    private let diaryEntry: DiaryEntry
    private let eventHandler: EventHandler
    
    var isExpanded: Bool = false
    var isShowingEditItem: Bool = false
    var addFoodItemViewModel: AddFoodItemViewModel?
    
    var name: String {
        diaryEntry.foodItem.name
    }
    
    var servingSize: String {
        String(Int(Double(diaryEntry.foodItem.servingSize) * diaryEntry.servings))
    }
    
    var measurement: String {
        diaryEntry.foodItem.measurementUnit.rawValue
    }
    
    var kcal: String {
        String(diaryEntry.totalCalories)
    }
    
    var carbs: String {
        String(format: "%.1f", diaryEntry.totalCarbs)
    }
    
    var protein: String {
        String(format: "%.1f", diaryEntry.totalProteins)
    }
    
    var fat: String {
        String(format: "%.1f", diaryEntry.totalFats)
    }
    
    @ObservationIgnored
    private lazy var createItemEventHandler: AddFoodItemViewModel.EventHandler = {
        AddFoodItemViewModel.EventHandler { _ in
            // TODO: this is unused, move edit to separate veiw
        } saveEntry: { [weak self] foodItem, servings async in
            guard let self else { return }
            await eventHandler.updateEntry(diaryEntry, servings)
        }
    }()
    
    init(diaryEntry: DiaryEntry, eventHandler: EventHandler) {
        self.diaryEntry = diaryEntry
        self.eventHandler = eventHandler
    }
    
    func toggleExpanded() {
        isExpanded.toggle()
    }
    
    func editDiaryEntryTapped() {
        let viewModel = AddFoodItemViewModel(
            eventHandler: createItemEventHandler,
            foodItem: diaryEntry.foodItem,
            servings: diaryEntry.servings
        )
        addFoodItemViewModel = viewModel
        isShowingEditItem = true
    }
    
    func removeDiaryEntryTapped() async {
        await eventHandler.removeEntryTapped(diaryEntry)
    }
}
