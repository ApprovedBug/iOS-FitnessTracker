//
//  FitnessTrackerApp.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 22/10/2023.
//

import SwiftUI
import SwiftData

@main
struct FitnessTrackerApp: App {
//    var sharedModelContainer: ModelContainer = {
//        let schema = Schema([
//            Item.self,
//        ])
//        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
//
//        do {
//            return try ModelContainer(for: schema, configurations: [modelConfiguration])
//        } catch {
//            fatalError("Could not create ModelContainer: \(error)")
//        }
//    }()

    var body: some Scene {
        WindowGroup {
            
            TabView {
                DiaryView()
                    .tabItem {
                        Image(systemName: "list.bullet.clipboard")
                    }
                
                ExerciseView()
                    .tabItem {
                        Image(systemName: "dumbbell")
                    }
                
                WeightView()
                    .tabItem {
                        Image(systemName: "chart.xyaxis.line")
                    }
                
                AccountView()
                    .tabItem {
                        Image(systemName: "person.crop.circle")
                    }
            }
        }
//        .modelContainer(sharedModelContainer)
    }
}
