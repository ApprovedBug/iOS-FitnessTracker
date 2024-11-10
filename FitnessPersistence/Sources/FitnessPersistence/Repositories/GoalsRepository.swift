//
//  GoalsRepository.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 06/04/2024.
//

import Combine
import DependencyManagement
import Foundation
import SwiftData

public enum GoalsError: Error {
    case fetchError
}

public protocol GoalsRepository: Sendable {
    
    func goalsForUser(userId: String) async -> AnyPublisher<Goals, GoalsError>
    func saveGoals(goals: Goals, for user: String) async
    func deleteGoals(for user: String) async
}

@MainActor
public struct LocalGoalsRepository: GoalsRepository {
    
    @Inject var contextProvider: ContextProviding
    
    public init() {}
    
    public func goalsForUser(userId: String) async -> AnyPublisher<Goals, GoalsError> {
        do {
            let descriptor = FetchDescriptor<Goals>()
            guard let entry = try contextProvider.sharedModelContainer.mainContext.fetch(descriptor).first else {
                return Fail(error: .fetchError).eraseToAnyPublisher()
            }
            return Just(entry).setFailureType(to: GoalsError.self).eraseToAnyPublisher()
        } catch {
            return Fail(error: .fetchError).eraseToAnyPublisher()
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
