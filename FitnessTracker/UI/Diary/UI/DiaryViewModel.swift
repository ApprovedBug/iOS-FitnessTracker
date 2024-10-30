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
    enum State {
        case idle
        case loading
        case error
        case ready(entries: [DiaryEntry])
    }
    
    // MARK: Injected dependencies
    @ObservationIgnored
    @Inject
    var diaryFetching: DiaryRepository
    
    // MARK: Published properties
    private(set) var state: State
    
    // MARK: Private properties
    @ObservationIgnored
    private var cancellables = [AnyCancellable]()
    
    // MARK: Initializers
    init() {
        state = .idle
    }
    
    // MARK: Internal functions
    func loadData() {
        
        diaryFetching.diaryEntries(for: Date())
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
                guard let self = self else { return }
                self.processEntries(entries: entries)
            }
            .store(in: &cancellables)
    }
    
    // MARK: Private functions
    private func processEntries(entries: [DiaryEntry]) {
        state = .ready(entries: entries)
    }
}
