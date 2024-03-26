//
//  DairyFetching.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 30/10/2023.
//

import Combine
import DependencyManagement
import FitnessPersistence
import Foundation
import SwiftData

enum DiaryError: Error {
    case fetchError
}

protocol DiaryFetching {
    
    func diaryEntries(for day: Date) -> AnyPublisher<[DiaryEntry], DiaryError>
}

struct MockDiaryRepository: DiaryFetching {
    
    @Inject var contextProvider: ContextProviding
    
    @MainActor func diaryEntries(for day: Date) -> AnyPublisher<[DiaryEntry], DiaryError> {
        
        do {
            let descriptor = FetchDescriptor<DiaryEntry>(sortBy: [SortDescriptor(\.timestamp)])
            let entries = try contextProvider.sharedModelContainer.mainContext.fetch(descriptor)
            return Just(entries).setFailureType(to: DiaryError.self).eraseToAnyPublisher()
        } catch {
            print("Fetch failed")
            return Fail(error: .fetchError).eraseToAnyPublisher()
        }
    }
}
