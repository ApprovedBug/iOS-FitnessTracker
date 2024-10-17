//
//  SummaryViewModel.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 22/10/2023.
//

import Combine
import DependencyManagement
import FitnessPersistence
import Foundation
    
@Observable
class SummaryViewModel {
    
    struct Data {
        let kcalConsumed: String
        let kcalBurned: String
        let kcalProgress: Double
        let kcalRemaining: String
        let carbsViewModel: MacrosViewModel
        let proteinViewModel: MacrosViewModel
        let fatsViewModel: MacrosViewModel
    }
    
    enum State {
        case idle
        case ready(Data)
    }
    
    // MARK: Injected properties
    
    @ObservationIgnored
    @Inject
    var goalsRepository: GoalsRepository
    
    // MARK: Published properties
    
    var state: State = .idle
    
    // MARK: Private properties
    
    @ObservationIgnored
    var cancellables = Set<AnyCancellable>()
    
    // MARK: Initialisers
    
    init(entries: [DiaryEntry]) {
        populateUI(entries: entries)
    }

    // MARK: - Private functions

    private func populateUI(entries: [DiaryEntry]) {
        goalsRepository.goalsForUser(userId: "something")
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print(error)
                case .finished:
                    print("Success")
                }
            } receiveValue: { [weak self] goals in
                guard let self = self else { return }
                
                // Calculate consumed values based on entries
                let (kcalConsumed, carbsConsumed, proteinsConsumed, fatsConsumed) = self.calculateConsumedValues(from: entries)
                
                // Create the view models
                let carbsViewModel = self.createMacrosViewModel(consumed: carbsConsumed, target: goals.carbs, title: "Carbs")
                let proteinsViewModel = self.createMacrosViewModel(consumed: proteinsConsumed, target: goals.protein, title: "Protein")
                let fatsViewModel = self.createMacrosViewModel(consumed: fatsConsumed, target: goals.fats, title: "Fat")
                
                // Update the state
                self.state = .ready(
                    .init(
                        kcalConsumed: String(kcalConsumed),
                        kcalBurned: "0",
                        kcalProgress: Double(kcalConsumed) / Double(goals.kcal),
                        kcalRemaining: String(format: "%.0f", Double(goals.kcal) - Double(kcalConsumed)),
                        carbsViewModel: carbsViewModel,
                        proteinViewModel: proteinsViewModel,
                        fatsViewModel: fatsViewModel
                    )
                )
            }
            .store(in: &cancellables)
    }

    // MARK: - Helper functions

    private func calculateConsumedValues(from entries: [DiaryEntry]) -> (Int, Double, Double, Double) {
        var kcalConsumed = 0
        var carbsConsumed = 0.0
        var proteinsConsumed = 0.0
        var fatsConsumed = 0.0
        
        entries.forEach { entry in
            kcalConsumed += entry.foodItem.kcal
            carbsConsumed += entry.foodItem.carbs
            proteinsConsumed += entry.foodItem.protein
            fatsConsumed += entry.foodItem.fats
        }
        
        return (kcalConsumed, carbsConsumed, proteinsConsumed, fatsConsumed)
    }

    private func createMacrosViewModel(consumed: Double, target: Double, title: String) -> MacrosViewModel {
        return MacrosViewModel(
            consumed: consumed,
            target: target,
            title: title
        )
    }
}
