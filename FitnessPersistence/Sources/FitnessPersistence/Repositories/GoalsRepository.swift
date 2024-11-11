//
//  GoalsRepository.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 06/04/2024.
//

import DependencyManagement
import Foundation
import SwiftData

public enum GoalsError: Error {
    case fetchError
}

public protocol GoalsRepository {
    
    @MainActor func goalsForUser(userId: String) -> Goals?
    @MainActor func saveGoals(goals: Goals, for user: String) async
    @MainActor func deleteGoals(for user: String) async
}

public struct LocalGoalsRepository: GoalsRepository {
    
    @Inject var contextProvider: ContextProviding
    
    public init() {}
    
    public func goalsForUser(userId: String) -> Goals? {
        do {
            let descriptor = FetchDescriptor<Goals>()
            guard let entry = try contextProvider.sharedModelContainer.mainContext.fetch(descriptor).first else {
                return nil  // Return nil if no entry is found
            }
            return entry
        } catch {
            return nil  // Return nil if there's an error
        }
    }
    
    public func saveGoals(goals: Goals, for user: String) async {
        contextProvider.sharedModelContainer.mainContext.insert(goals)
        try? contextProvider.sharedModelContainer.mainContext.save()
    }
    
    public func deleteGoals(for user: String) async {
        try? contextProvider.sharedModelContainer.mainContext.delete(model: Goals.self)
    }
}
