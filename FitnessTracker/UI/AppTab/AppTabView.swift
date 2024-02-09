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
            DiaryView(viewModel: DiaryViewModel())
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
}
