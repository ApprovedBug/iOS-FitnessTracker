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
import SwiftUI

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
    private(set) var state: State = .idle
    
    // MARK: Private properties
    private var disposables = [AnyCancellable]()
    
    // MARK: Initializers
    init() { }
    
    // MARK: Internal functions
    func loadData() {
        
    }
    
    // MARK: Private functions
    private func processEntries(entries: [DiaryEntry]) {
        state = .ready(entries: entries)
    }
}
