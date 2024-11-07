//
//  AddDiaryEntryViewModel.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 02/08/2024.
//

import Combine
import DependencyManagement
import FitnessPersistence
import Foundation
import SwiftUI

@Observable
class AddDiaryEntryViewModel {
    
    struct EventHandler {
        var diaryEntryAdded: (DiaryEntry) -> Void
        var diaryEntriesAdded: ([DiaryEntry]) -> Void
    }
    
    enum State {
        case idle
        case loading
        case searchResults(items: [FoodItemViewModel], meals: [MealItemViewModel])
        case empty
    }
    
    var isShowingCreateNewFoodItem: Bool = false
    var isShowingAddExistingItem: Bool = false
    var shouldDismiss: Bool = false
    var searchText: String = ""
    var state: State = .idle
    var addFoodItemViewModel: AddFoodItemViewModel?
    
    let date: Date
    let mealType: MealType
    let eventHandler: EventHandler?
    
    @ObservationIgnored
    @Inject private var foodItemRepository: FoodItemRepository
    
    @ObservationIgnored
    @Inject private var diaryRepository: DiaryRepository
    
    @ObservationIgnored
    @Inject private var mealsRepository: MealsRepository
    
    @ObservationIgnored
    private var cancellables = [AnyCancellable]()
    
    @ObservationIgnored
    private var meals: [Meal] = []
    
    @ObservationIgnored
    private lazy var itemEventHandler: FoodItemViewModel.EventHandler = {
        FoodItemViewModel.EventHandler { [weak self] foodItem in
            self?.addDiaryEntry(foodItem)
        }
    }()
    
    @ObservationIgnored
    private lazy var mealItemEventHandler: MealItemViewModel.EventHandler = {
        MealItemViewModel.EventHandler { [weak self] meal in
            self?.addMeal(meal)
        }
    }()
    
    @ObservationIgnored
    private lazy var createItemEventHandler: AddFoodItemViewModel.EventHandler = {
        AddFoodItemViewModel.EventHandler(
            didCreateFoodItem: { [weak self] item in
                guard let self else { return }
                addDiaryEntry(item)
                shouldDismiss = true
            }) { [weak self] foodItem, servings in
                self?.addDiaryEntry(foodItem, servings: servings)
            }
    }()
    
    init(date: Date, mealType: MealType, eventHandler: EventHandler? = nil) {
        self.date = date
        self.mealType = mealType
        self.eventHandler = eventHandler
        
        loadInitialState()
    }
    
    func createFoodItemTapped() {
        let viewModel = AddFoodItemViewModel(eventHandler: createItemEventHandler)
        addFoodItemViewModel = viewModel
        isShowingCreateNewFoodItem = true
    }
    
    func addFoodItemTapped(_ foodItem: FoodItem) {
        let viewModel = AddFoodItemViewModel(eventHandler: createItemEventHandler, foodItem: foodItem)
        addFoodItemViewModel = viewModel
        isShowingAddExistingItem = true
    }
    
    func loadInitialState() {
        
        loadRecentItems()
            .zip(loadMeals())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
            switch completion {
                case .finished:
                    break
                case .failure:
                    self?.state = .empty
            }
        }, receiveValue: { [weak self] results in
            guard let self else { return }
            let recentItems = results.0.map { FoodItemViewModel(foodItem: $0, eventHandler: itemEventHandler) }
            let mealsFoodItems = results.1.map { MealItemViewModel(meal: $0, eventHandler: mealItemEventHandler) }
            state = .searchResults(items: recentItems, meals: mealsFoodItems)
        })
        .store(in: &cancellables)
    }
    
    func loadRecentItems() -> AnyPublisher<Set<FoodItem>, Never> {
        foodItemRepository.recentFoodItems().replaceError(with: []).eraseToAnyPublisher()
    }
    
    func loadMeals() -> AnyPublisher<[Meal], Never>{
        mealsRepository.meals().replaceError(with: []).eraseToAnyPublisher()
    }
    
    func search() {
        state = .loading
        
        foodItemRepository.foodItems(name: searchText)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                    case .finished:
                        break
                    case .failure:
                        self?.state = .empty
                }
            } receiveValue: { [weak self] items in
                guard let self else { return }
                if items.isEmpty {
                    state = .empty
                } else {
                    let viewModels = items.map { FoodItemViewModel(foodItem: $0, eventHandler: itemEventHandler) }
                    state = .searchResults(items: viewModels, meals: [])
                }
            }
            .store(in: &cancellables)
    }
    
    func addDiaryEntry(_ foodItem: FoodItem, servings: Double = 1) {
        let diaryEntry = DiaryEntry(timestamp: date, foodItem: foodItem, mealType: mealType, servings: servings)
        diaryRepository.addDiaryEntry(diaryEntry: diaryEntry)
        eventHandler?.diaryEntryAdded(diaryEntry)
    }
    
    func addMeal(_ meal: Meal?) {
        guard let meal else { return }
        
        let diaryEntries = meal.foodItems.map { mealFoodItem in
            DiaryEntry(
                timestamp: date,
                foodItem: mealFoodItem.foodItem,
                mealType: mealType,
                servings: mealFoodItem.servings
            )
        }
        diaryRepository.addDiaryEntries(diaryEntries: diaryEntries)
        eventHandler?.diaryEntriesAdded(diaryEntries)
    }
}
