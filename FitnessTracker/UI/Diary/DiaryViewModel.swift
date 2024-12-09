//
//  DiaryViewModel.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 22/10/2023.
//

import Combine
import DependencyManagement
@preconcurrency import FitnessPersistence
import Foundation
import SwiftData

@Observable
@MainActor
class DiaryViewModel {
    
    // MARK: Page state
    enum State: Equatable {
        case idle
        case loading
        case error
        case ready
    }
    
    // MARK: Injected dependencies
    @ObservationIgnored
    @Inject
    var diaryRepository: DiaryRepository
    
    @ObservationIgnored
    @Inject
    private var goalsRepository: GoalsRepository
    
    @ObservationIgnored
    @Inject
    var mealsRepository: MealsRepository
    
    // MARK: Published properties
    var state: State = .idle
    private(set) var dateViewModel: DatePickerViewModel
    private(set) var summaryViewModel: SummaryViewModel?
    private(set) var mealListViewModel: MealListViewModel?
    private(set) var addDiaryEntryViewModel: AddDiaryEntryViewModel?
    private(set) var addFoodItemViewModel: AddFoodItemViewModel?
    var isAddDiaryEntryOpen: Bool = false
    var isShowingSaveMealAlert: Bool = false
    var isShowingEditItem: Bool = false
    var editingItem:  DiaryEntry?
    var mealName: String = ""
    var mealNameValid: Bool {
        !mealName.isEmpty
    }
    
    // MARK: Private properties
    @ObservationIgnored
    private var cancellables = [AnyCancellable]()
    @ObservationIgnored
    private var allEntries: [DiaryEntry] = []
    @ObservationIgnored
    private var mealEntriesToSave: [DiaryEntry] = []
    
    @ObservationIgnored
    @MainActor
    private lazy var addDiaryEntryEventHandler: AddDiaryEntryViewModel.EventHandler = {
        let addDiaryEntryEventHandler = AddDiaryEntryViewModel.EventHandler(
            diaryEntryAdded: { [weak self] entry in
                // new entry added
                guard let self else { return }
                allEntries.append(entry)
                processEntries(entries: allEntries, date: dateViewModel.currentSelectedDate)
            }) { [weak self] entries in
                // new meal added
                guard let self else { return }
                allEntries.append(contentsOf: entries)
                processEntries(entries: allEntries, date: dateViewModel.currentSelectedDate)
            }
        return addDiaryEntryEventHandler
    }()
    
    @ObservationIgnored
    private lazy var editItemEventHandler: AddFoodItemViewModel.EventHandler = {
        AddFoodItemViewModel.EventHandler { _ in
            // TODO: this is unused, move edit to separate veiw
        } saveEntry: { [weak self] foodItem, servings async in
            guard let self else { return }
            editingItem?.servings = servings
            let entries = allEntries.filter { Calendar.current.isDate($0.timestamp, inSameDayAs: dateViewModel.currentSelectedDate) }
            processEntries(entries: entries, date: dateViewModel.currentSelectedDate)
        }
    }()
    
    // MARK: Initializers
    init() {
        dateViewModel = DatePickerViewModel(date: Date.now)
        
        subscribeDateUpdates()
    }
    
    // MARK: Internal functions
    
    func loadData() {
        
        let goals = goalsRepository.goalsForUser(userId: "something")
        allEntries = diaryRepository.all()
        
        let entries = allEntries.filter { Calendar.current.isDate($0.timestamp, inSameDayAs: Date.now) }
        
        if let goals {
            summaryViewModel = SummaryViewModel(goals: goals, entries: entries)
        }
        mealListViewModel = MealListViewModel(entries: entries)
        subscribeToEntryUpdates()
        
        state = .ready
    }
    
    func saveMealTapped() {
        let foodItems = mealEntriesToSave.map { MealFoodItem(servings: $0.servings, foodItem:$0.foodItem) }
        let meal = Meal(name: mealName, foodItems: foodItems)
        mealsRepository.saveMeal(meal)
        isShowingSaveMealAlert = false
    }
    
    // MARK: Private functions
    
    private func subscribeToEntryUpdates() {
        
        let eventHandler = MealListViewModel.EventHandler { [weak self] mealType in
            guard let self else { return }
            addDiaryEntryViewModel = AddDiaryEntryViewModel(
                date: dateViewModel.currentSelectedDate,
                mealType: mealType,
                eventHandler: addDiaryEntryEventHandler
            )
            isAddDiaryEntryOpen = true
        } removeEntryTapped: { [weak self] entry in
            guard let self else { return }
            diaryRepository.remove(diaryEntry: entry)
            allEntries.removeAll(where: { $0.id == entry.id })
            let entries = allEntries.filter { Calendar.current.isDate($0.timestamp, inSameDayAs: dateViewModel.currentSelectedDate) }
            processEntries(entries: entries, date: dateViewModel.currentSelectedDate)
        } editEntryTapped: { [weak self] entry in
            guard let self else { return }
            editingItem = entry
            let viewModel = AddFoodItemViewModel(
                eventHandler: editItemEventHandler,
                foodItem: entry.foodItem,
                servings: entry.servings
            )
            addFoodItemViewModel = viewModel
            isShowingEditItem = true
        } saveMealTapped: { [weak self] entries in
            guard let self else { return }
            mealEntriesToSave = entries
            isShowingSaveMealAlert = true
        }

        mealListViewModel?.setEventHandler(eventHandler: eventHandler)
    }
    
    private func processEntries(entries: [DiaryEntry], date: Date) {
        let entries = entries.filter { Calendar.current.isDate($0.timestamp, inSameDayAs: date) }
        
        summaryViewModel?.updateEntries(with: entries)
        mealListViewModel?.updateEntries(entries: entries)
    }
    
    private func subscribeDateUpdates() {
        dateViewModel.date.sink { [weak self] date in
            guard let self else { return }
            
            processEntries(entries: allEntries, date: date)
        }
        .store(in: &cancellables)
    }
}
