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
class MealListItemViewModel: Identifiable {

    struct EventHandler {
        let openAddDiaryEntryTapped: (MealType) -> Void
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
    var isShowingSaveMealAlert: Bool = false
    var mealName: String = ""
    var mealNameValid: Bool {
        !mealName.isEmpty
    }

    private var entries: [DiaryEntry] = []
    
    @ObservationIgnored
    let mealType: MealType
    
    @ObservationIgnored
    let eventHandler: EventHandler?
    
    @ObservationIgnored
    @Inject
    var diaryRepository: DiaryRepository
    
    @ObservationIgnored
    @Inject
    var mealsRepository: MealsRepository
    
    // MARK: Initialisers
    
    init(
        mealType: MealType,
        entries: [DiaryEntry],
        eventHandler: MealListItemViewModel.EventHandler? = nil
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
    
    func addEntryTapped() {
        eventHandler?.openAddDiaryEntryTapped(mealType)
    }
    
    func removeEntry(diaryEntry: DiaryEntry) async {
        diaryRepository.remove(diaryEntry: diaryEntry)
        eventHandler?.diaryEntryRemoved(diaryEntry)
        entries.removeAll(where: { $0.id == diaryEntry.id })
        populateUI()
    }
    
    func updateEntry(diaryEntry: DiaryEntry, servings: Double) {
        diaryEntry.servings = servings
        eventHandler?.diaryEntryUpdated(diaryEntry)
        populateUI()
    }
    
    func saveMealTapped() async {
        
        guard isShowingSaveMealAlert else {
            isShowingSaveMealAlert = true
            return
        }
        let foodItems = entries.map { MealFoodItem(servings: $0.servings, foodItem:$0.foodItem) }
        let meal = Meal(name: mealName, foodItems: foodItems)
        mealsRepository.saveMeal(meal)
        isShowingSaveMealAlert = false
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
        
        let mealEntryViewModels: [MealEntryViewModel] = entries.map {
            let eventHandler = MealEntryViewModel.EventHandler { [weak self] entry async in
                await self?.removeEntry(diaryEntry: entry)
            } updateEntry: { [weak self] entry, servings in
                self?.updateEntry(diaryEntry: entry, servings: servings)
            }

            return MealEntryViewModel(diaryEntry: $0, eventHandler: eventHandler)
        }
        
        state = .ready(
            .init(
                mealTitle: NSLocalizedString("meal_\(mealType)", comment: "Meal title"),
                entries: mealEntryViewModels,
                kcalConsumed: String(kcalConsumed),
                proteinsConsumed: String(format: "%.1f", proteinsConsumed),
                fatsConsumed: String(format: "%.1f", fatsConsumed),
                carbsConsumed: String(format: "%.1f", carbsConsumed)
            )
        )
    }
}
