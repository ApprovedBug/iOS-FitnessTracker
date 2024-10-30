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
        case success(items: [FoodItem])
        case empty
    }
    
    var isCreateFoodItemOpen: Bool = false
    var searchText: String = ""
    var state: State = .idle
    
    @ObservationIgnored
    @Inject var foodItemRepository: FoodItemRepository
    
    @ObservationIgnored
    private var cancellables = [AnyCancellable]()
    
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
                    self?.state = .success(items: items)
                }
            }
            .store(in: &cancellables)
    }
}
