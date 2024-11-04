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
        var diaryEntryAdded:  (DiaryEntry) -> Void
    }
    
    enum State {
        case idle
        case recentItems(items: [FoodItemViewModel])
        case noRecentItems
        case loading
        case searchResults(items: [FoodItemViewModel])
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
    private var cancellables = [AnyCancellable]()
    
    @ObservationIgnored
    private lazy var itemEventHandler: FoodItemViewModel.EventHandler = {
        FoodItemViewModel.EventHandler { [weak self] foodItem in
            self?.addDiaryEntry(foodItem)
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
        
        loadRecentItems()
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
    
    func loadRecentItems() {
        
        state = .loading
        
        foodItemRepository.recentFoodItems()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                    case .finished:
                        break
                    case .failure:
                        self?.state = .noRecentItems
                }
            } receiveValue: { [weak self] items in
                guard let self else { return }
                if items.isEmpty {
                    state = .noRecentItems
                } else {
                    let viewModels = items.map { FoodItemViewModel(foodItem: $0, eventHandler: itemEventHandler) }
                    state = .recentItems(items: viewModels)
                }
            }
            .store(in: &cancellables)
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
                    state = .searchResults(items: viewModels)
                }
            }
            .store(in: &cancellables)
    }
    
    func addDiaryEntry(_ foodItem: FoodItem, servings: Double = 1) {
        let diaryEntry = DiaryEntry(timestamp: date, foodItem: foodItem, mealType: mealType, servings: servings)
        diaryRepository.addDiaryEntry(diaryEntry: diaryEntry)
        eventHandler?.diaryEntryAdded(diaryEntry)
    }
}
