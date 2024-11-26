//
//  DairyFetching.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 30/10/2023.
//

import DependencyManagement
import Foundation
import SwiftData

public enum DiaryError: Error {
    case fetchError
}

public protocol DiaryRepository {
    
    @MainActor func all() -> [DiaryEntry]
    @MainActor func add(diaryEntry: DiaryEntry)
    @MainActor func add(diaryEntries: [DiaryEntry])
    @MainActor func remove(diaryEntry: DiaryEntry)
}

public struct LocalDiaryRepository: DiaryRepository {
    
    @Inject var contextProvider: ContextProviding
    
    public init() {}
    
    public func all() -> [DiaryEntry] {
        
        do {
            let descriptor = FetchDescriptor<DiaryEntry>(sortBy: [SortDescriptor(\.timestamp)])
            let entries = try contextProvider.sharedModelContainer.mainContext.fetch(descriptor)
            return entries
        } catch {
            return []
        }
    }
    
    public func add(diaryEntry: DiaryEntry) {
        contextProvider.sharedModelContainer.mainContext.insert(diaryEntry)
        try? contextProvider.sharedModelContainer.mainContext.save()
    }
    
    public func add(diaryEntries: [DiaryEntry]) {
        diaryEntries.forEach { entry in
            contextProvider.sharedModelContainer.mainContext.insert(entry)
        }
        try? contextProvider.sharedModelContainer.mainContext.save()
    }
    
    public func remove(diaryEntry: DiaryEntry) {
        contextProvider.sharedModelContainer.mainContext.delete(diaryEntry)
        try? contextProvider.sharedModelContainer.mainContext.save()
    }
}
