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
    private var goalsRepository: GoalsRepository
    
    // MARK: Published properties
    
    var state: State = .idle
    
    // MARK: Private properties
    
    @ObservationIgnored
    private var cancellables = Set<AnyCancellable>()
    
    @ObservationIgnored
    private var goals: Goals?
    
    // MARK: Initialisers
    
    init() {
        loadGoals()
    }

    // MARK: - Private functions

    private func loadGoals() {
        goalsRepository.goalsForUser(userId: "something")
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("SummaryViewModel: \(error)")
                case .finished:
                    break
                }
            } receiveValue: { [weak self] goals in
                guard let self else { return }
                self.goals = goals
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Public functions
    
    func updateEntries(with entries: [DiaryEntry]) {
        guard let goals else { return }
        process(goals: goals, entries: entries)
    }

    // MARK: - Helper functions
    
    private func process(goals: Goals, entries: [DiaryEntry]) {
        
        // Calculate consumed values based on entries
        let (kcalConsumed, carbsConsumed, proteinsConsumed, fatsConsumed) = self.calculateConsumedValues(from: entries)
        
        // Create the view models
        let carbsViewModel = createMacrosViewModel(consumed: carbsConsumed, target: goals.carbs, title: "Carbs")
        let proteinsViewModel = createMacrosViewModel(consumed: proteinsConsumed, target: goals.protein, title: "Protein")
        let fatsViewModel = createMacrosViewModel(consumed: fatsConsumed, target: goals.fats, title: "Fat")
        
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

    private func calculateConsumedValues(from entries: [DiaryEntry]) -> (Int, Double, Double, Double) {
        var kcalConsumed = 0
        var carbsConsumed = 0.0
        var proteinsConsumed = 0.0
        var fatsConsumed = 0.0
        
        entries.forEach { entry in
            kcalConsumed += entry.totalCalories
            carbsConsumed += entry.totalCarbs
            proteinsConsumed += entry.totalProteins
            fatsConsumed += entry.totalFats
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
