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

public protocol DiaryRepository: Sendable {
    
    @MainActor func allDiaryEntries() async -> AnyPublisher<[DiaryEntry], DiaryError>
    @MainActor func addDiaryEntry(diaryEntry: DiaryEntry) async
    @MainActor func addDiaryEntries(diaryEntries: [DiaryEntry]) async
    @MainActor func removeDiaryEntry(diaryEntry: DiaryEntry) async
}

@MainActor
public struct LocalDiaryRepository: DiaryRepository {
    
    @Inject var contextProvider: ContextProviding
    
    public init() {}
    
    public func allDiaryEntries() async -> AnyPublisher<[DiaryEntry], DiaryError> {
        
        do {
            let descriptor = FetchDescriptor<DiaryEntry>(sortBy: [SortDescriptor(\.timestamp)])
            let entries = try contextProvider.sharedModelContainer.mainContext.fetch(descriptor)
            return Just(entries).setFailureType(to: DiaryError.self).eraseToAnyPublisher()
        } catch {
            return Fail(error: .fetchError).eraseToAnyPublisher()
        }
    }
    
    public func addDiaryEntry(diaryEntry: DiaryEntry) async {
        contextProvider.sharedModelContainer.mainContext.insert(diaryEntry)
        try? contextProvider.sharedModelContainer.mainContext.save()
    }
    
    public func addDiaryEntries(diaryEntries: [DiaryEntry]) async {
        diaryEntries.forEach { entry in
            contextProvider.sharedModelContainer.mainContext.insert(entry)
        }
        try? contextProvider.sharedModelContainer.mainContext.save()
    }
    
    public func removeDiaryEntry(diaryEntry: DiaryEntry) async {
        contextProvider.sharedModelContainer.mainContext.delete(diaryEntry)
        try? contextProvider.sharedModelContainer.mainContext.save()
    }
}
