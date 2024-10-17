//
//  PersistanceManager.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 21/11/2023.
//

import Foundation
import SwiftData

public protocol ContextProviding {
    
    var sharedModelContainer: ModelContainer { get }
}

public struct PersistenceManager: ContextProviding {
    
    public init() { }
    
    public var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            DiaryEntry.self,
            FoodItem.self,
            Goals.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
}
