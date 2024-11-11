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
    var diaryFetching: DiaryRepository
    
    @ObservationIgnored
    @Inject
    private var goalsRepository: GoalsRepository
    
    // MARK: Published properties
    var state: State = .idle
    private(set) var dateViewModel: DatePickerViewModel
    private(set) var summaryViewModel: SummaryViewModel?
    private(set) var mealListViewModel: MealListViewModel?
    
    // MARK: Private properties
    @ObservationIgnored
    private var cancellables = [AnyCancellable]()
    @ObservationIgnored
    private var allEntries = [DiaryEntry]()
    
    // MARK: Initializers
    init() {
        dateViewModel = DatePickerViewModel(date: Date.now)
        
        subscribeToEntryUpdates()
        subscribeDateUpdates()
    }
    
    // MARK: Internal functions
    
    func loadData() {
        
        let goals = goalsRepository.goalsForUser(userId: "something")
        let entries = diaryFetching.allDiaryEntries()
        
        if let goals {
            summaryViewModel = SummaryViewModel(goals: goals, entries: entries)
        }
        mealListViewModel = MealListViewModel(currentlySelectedDate: Date.now, entries: entries)
        allEntries = entries
        state = .ready
    }
    
    // MARK: Private functions
    
    private func subscribeToEntryUpdates() {
        let eventHandler = MealListViewModel.EventHandler(
            diaryEntryAdded: { [weak self] diaryEntry in
                guard let self else { return }
                allEntries.append(diaryEntry)
                let entries = allEntries.filter { Calendar.current.isDate($0.timestamp, inSameDayAs: dateViewModel.currentSelectedDate) }
                summaryViewModel?.updateEntries(with: entries)
            }, diaryEntryRemoved: { [weak self] entry in
                guard let self else { return }
                allEntries.removeAll(where: { $0.id == entry.id })
                let entries = allEntries.filter { Calendar.current.isDate($0.timestamp, inSameDayAs: dateViewModel.currentSelectedDate) }
                summaryViewModel?.updateEntries(with: entries)
            }, diaryEntryUpdated: { [weak self] entry in
                guard let self else { return }
                let entries = allEntries.filter { Calendar.current.isDate($0.timestamp, inSameDayAs: dateViewModel.currentSelectedDate) }
                summaryViewModel?.updateEntries(with: entries)
            }
        )
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
            
            mealListViewModel?.updateCurrentlySelectedDate(to: date)
            processEntries(entries: allEntries, date: date)
        }
        .store(in: &cancellables)
    }
}
