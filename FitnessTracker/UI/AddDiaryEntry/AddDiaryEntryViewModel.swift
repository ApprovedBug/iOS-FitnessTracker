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
    
    enum State {
        case idle
        case loading
        case success(items: [FoodItemViewModel])
        case empty
    }
    
    var isCreateFoodItemOpen: Bool = false
    var searchText: String = ""
    var state: State = .idle
    
    let meal: Meal
    
    @ObservationIgnored
    @Inject private var foodItemRepository: FoodItemRepository
    
    @ObservationIgnored
    @Inject private var diaryRepository: DiaryRepository
    
    @ObservationIgnored
    private var cancellables = [AnyCancellable]()
    
    init(meal: Meal) {
        self.meal = meal
    }
    
    func createFoodItemTapped() {
        isCreateFoodItemOpen = true
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
        diaryRepository.addDiaryEntry(foodItem: foodItem, meal: meal, day: Date.now)
    }
}
