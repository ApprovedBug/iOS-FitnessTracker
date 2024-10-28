//
//  TabView.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 21/11/2023.
//

import Foundation
import SwiftUI

struct AppTabView: View {
    // Define a state variable to keep track of the selected tab
    @State private var selectedTab = 0
    
    var body: some View {
        
        NavigationStack {
            TabView(selection: $selectedTab) {
                
                Tab("Diary", systemImage: "list.bullet.clipboard", value: 0) {
                    DiaryView(viewModel: DiaryViewModel())
                }
                
                Tab("Exercise", systemImage: "dumbbell", value: 1) {
                    ExerciseView()
                }
                
                Tab("Weight", systemImage: "chart.xyaxis.line", value: 2) {
                    WeightView()
                }
                
                Tab("Account", systemImage: "person.crop.circle", value: 3) {
                    AccountView()
                }
            }
            .navigationTitle(tabTitle(for: selectedTab))
        }
    }
    
    // Function to return the title based on the selected tab index
    private func tabTitle(for index: Int) -> String {
        switch index {
        case 0:
            return "Diary"
        case 1:
            return "Exercise"
        case 2:
            return "Weight"
        case 3:
            return "Account"
        default:
            return "Diary" // Default case
        }
    }
}
