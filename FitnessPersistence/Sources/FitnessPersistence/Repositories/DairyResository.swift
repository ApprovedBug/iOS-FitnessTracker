//
//  DairyFetching.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 30/10/2023.
//

import Combine
import DependencyManagement
import Foundation
import SwiftData

public enum DiaryError: Error {
    case fetchError
}

public protocol DiaryRepository {
    
    func allDiaryEntries() -> AnyPublisher<[DiaryEntry], DiaryError>
    func addDiaryEntry(diaryEntry: DiaryEntry)
    func addDiaryEntries(diaryEntries: [DiaryEntry])
    func removeDiaryEntry(diaryEntry: DiaryEntry)
}

public struct LocalDiaryRepository: @preconcurrency DiaryRepository {
    
    @Inject var contextProvider: ContextProviding
    
    public init() {}
    
    @MainActor public func allDiaryEntries() -> AnyPublisher<[DiaryEntry], DiaryError> {
        
        do {
            let descriptor = FetchDescriptor<DiaryEntry>(sortBy: [SortDescriptor(\.timestamp)])
            let entries = try contextProvider.sharedModelContainer.mainContext.fetch(descriptor)
            return Just(entries).setFailureType(to: DiaryError.self).eraseToAnyPublisher()
        } catch {
            return Fail(error: .fetchError).eraseToAnyPublisher()
        }
    }
    
    @MainActor public func addDiaryEntry(diaryEntry: DiaryEntry) {
        contextProvider.sharedModelContainer.mainContext.insert(diaryEntry)
        try? contextProvider.sharedModelContainer.mainContext.save()
    }
    
    @MainActor public func addDiaryEntries(diaryEntries: [DiaryEntry]) {
        diaryEntries.forEach { entry in
            contextProvider.sharedModelContainer.mainContext.insert(entry)
        }
        try? contextProvider.sharedModelContainer.mainContext.save()
    }
    
    @MainActor public func removeDiaryEntry(diaryEntry: DiaryEntry) {
        contextProvider.sharedModelContainer.mainContext.delete(diaryEntry)
        try? contextProvider.sharedModelContainer.mainContext.save()
    }
}
