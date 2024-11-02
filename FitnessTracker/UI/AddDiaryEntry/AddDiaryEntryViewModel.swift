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
        case success(items: [FoodItemViewModel])
        case empty
    }
    
    var isCreateFoodItemOpen: Bool = false
    var searchText: String = ""
    var state: State = .idle
    
    let date: Date
    let meal: Meal
    let eventHandler: EventHandler?
    
    @ObservationIgnored
    @Inject private var foodItemRepository: FoodItemRepository
    
    @ObservationIgnored
    @Inject private var diaryRepository: DiaryRepository
    
    @ObservationIgnored
    private var cancellables = [AnyCancellable]()
    
    init(date: Date, meal: Meal, eventHandler: EventHandler? = nil) {
        self.date = date
        self.meal = meal
        self.eventHandler = eventHandler
        
        loadRecentItems()
    }
    
    func createFoodItemTapped() {
        isCreateFoodItemOpen = true
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
                if items.isEmpty {
                    self?.state = .noRecentItems
                } else {
                    let viewModels = items.map { FoodItemViewModel(foodItem: $0) }
                    self?.state = .recentItems(items: viewModels)
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
                if items.isEmpty {
                    self?.state = .empty
                } else {
                    let viewModels = items.map { FoodItemViewModel(foodItem: $0) }
                    self?.state = .success(items: viewModels)
                }
            }
            .store(in: &cancellables)
    }
    
    func addFoodItem(_ foodItem: FoodItem) {
        let diaryEntry = DiaryEntry(timestamp: date, foodItem: foodItem, meal: meal)
        diaryRepository.addDiaryEntry(diaryEntry: diaryEntry)
        eventHandler?.diaryEntryAdded(diaryEntry)
    }
}
