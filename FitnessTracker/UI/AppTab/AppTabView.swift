//
//  TabView.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 21/11/2023.
//

import Foundation
import SwiftUI

struct AppTabView: View {
    
    var body: some View {
        
        TabView {
            
            Tab("Diary", systemImage: "list.bullet.clipboard") {
                NavigationStack {
                    DiaryView(viewModel: DiaryViewModel())
                        .navigationTitle("Diary")
                }
            }
            
            Tab("Exercise", systemImage: "dumbbell") {
                ExerciseView()
            }
            
            Tab("Weight", systemImage: "chart.xyaxis.line") {
                WeightView()
            }
            
            Tab("Account", systemImage: "person.crop.circle") {
                AccountView()
            }
        }
    }
}
