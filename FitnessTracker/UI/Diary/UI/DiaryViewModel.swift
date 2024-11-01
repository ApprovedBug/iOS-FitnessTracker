//
//  DiaryViewModel.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 22/10/2023.
//

import Combine
import DependencyManagement
import FitnessPersistence
import Foundation
import SwiftData

@Observable
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
    var diaryFetching: DiaryRepository
    
    // MARK: Published properties
    var state: State
    private(set) var dateViewModel: DatePickerViewModel
    private(set) var summaryViewModel: SummaryViewModel
    private(set) var mealListViewModel: MealListViewModel
    
    // MARK: Private properties
    @ObservationIgnored
    private var cancellables = [AnyCancellable]()
    @ObservationIgnored
    private var allEntries = [DiaryEntry]()
    
    // MARK: Initializers
    init() {
        state = .idle
        self.dateViewModel = DatePickerViewModel(date: Date.now)
        self.summaryViewModel = SummaryViewModel()
        self.mealListViewModel = MealListViewModel()
        
        subscribeDateUpdates()
    }
    
    // MARK: Internal functions
    func loadData() {
        
        diaryFetching.diaryEntries()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .failure(_):
                    self.state = .error
                case .finished:
                    break
                }
            }) { [weak self] entries in
                guard let self else { return }
                self.allEntries = entries
                self.processEntries(entries: entries, date: self.dateViewModel.currentSelectedDate)
            }
            .store(in: &cancellables)
    }
    
    // MARK: Private functions
    private func processEntries(entries: [DiaryEntry], date: Date) {
        let entries = entries.filter { Calendar.current.isDate($0.timestamp, inSameDayAs: date) }
        state = .ready
        summaryViewModel.updateEntries(with: entries)
        mealListViewModel.updateEntries(entries: entries)
    }
    
    private func subscribeDateUpdates() {
        dateViewModel.date.sink { [weak self] date in
            guard let self else { return }
            
            processEntries(entries: allEntries, date: date)
        }
        .store(in: &cancellables)
    }
}
