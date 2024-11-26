//
//  WeightRepository.swift
//  FitnessPersistence
//
//  Created by Jack Moseley on 24/11/2024.
//

import DependencyManagement
import Foundation
import SwiftData

public protocol WeightRepository {
    @MainActor func all() -> [WeightEntry]
    @MainActor func save(entry: WeightEntry)
    @MainActor func remove(entry: WeightEntry)
}

public struct LocalWeightRepository: WeightRepository {
    
    @Inject var contextProvider: ContextProviding
    
    public init() {}
    
    @MainActor public func all() -> [WeightEntry] {
        do {
            let descriptor = FetchDescriptor<WeightEntry>(sortBy: [SortDescriptor(\.date)])
            let entries = try contextProvider.sharedModelContainer.mainContext.fetch(descriptor)
            return entries
        } catch {
            return []
        }
    }
    
    @MainActor public func save(entry: WeightEntry) {
        contextProvider.sharedModelContainer.mainContext.insert(entry)
        try? contextProvider.sharedModelContainer.mainContext.save()
    }
    
    @MainActor public func remove(entry: WeightEntry) {
        contextProvider.sharedModelContainer.mainContext.delete(entry)
        try? contextProvider.sharedModelContainer.mainContext.save()
    }
}
