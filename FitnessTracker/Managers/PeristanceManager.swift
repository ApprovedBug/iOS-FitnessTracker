//
//  PersistanceManager.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 21/11/2023.
//

import Foundation
import SwiftData

protocol ContextProviding {
    
    var sharedModelContainer: ModelContainer { get }
}

struct PersistanceManager: ContextProviding {
    
    init() {}
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            DiaryEntry.self,
            FoodItem.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
}
