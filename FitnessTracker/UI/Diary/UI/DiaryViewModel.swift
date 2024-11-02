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
        dateViewModel = DatePickerViewModel(date: Date.now)
        summaryViewModel = SummaryViewModel()
        mealListViewModel = MealListViewModel(currentlySelectedDate: Date.now)
        
        subscribeToEntryUpdates()
        subscribeDateUpdates()
    }
    
    // MARK: Internal functions
    func loadData() {
        
        diaryFetching.allDiaryEntries()
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
    
    private func subscribeToEntryUpdates() {
        let eventHandler = MealListViewModel.EventHandler(
            diaryEntryAdded: { [weak self] diaryEntry in
                guard let self else { return }
                allEntries.append(diaryEntry)
                let entries = allEntries.filter { Calendar.current.isDate($0.timestamp, inSameDayAs: dateViewModel.currentSelectedDate) }
                summaryViewModel.updateEntries(with: entries)
            }, diaryEntryRemoved: { [weak self] entry in
                guard let self else { return }
                allEntries.removeAll(where: { $0.id == entry.id })
                let entries = allEntries.filter { Calendar.current.isDate($0.timestamp, inSameDayAs: dateViewModel.currentSelectedDate) }
                summaryViewModel.updateEntries(with: entries)
            }
        )
        mealListViewModel.setEventHandler(eventHandler: eventHandler)
    }
    
    
    private func processEntries(entries: [DiaryEntry], date: Date) {
        let entries = entries.filter { Calendar.current.isDate($0.timestamp, inSameDayAs: date) }
        
        state = .ready
        
        summaryViewModel.updateEntries(with: entries)
        mealListViewModel.updateEntries(entries: entries)
    }
    
    private func subscribeDateUpdates() {
        dateViewModel.date.sink { [weak self] date in
            guard let self else { return }
            
            mealListViewModel.updateCurrentlySelectedDate(to: date)
            processEntries(entries: allEntries, date: date)
        }
        .store(in: &cancellables)
    }
}
