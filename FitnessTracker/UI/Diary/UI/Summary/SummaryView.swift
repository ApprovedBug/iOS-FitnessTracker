//
//  SummaryView.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 22/10/2023.
//

import FitnessPersistence
import FitnessUI
import Foundation
import SwiftUI

struct SummaryView: View {
    
    @Bindable var viewModel: SummaryViewModel
    
    var body: some View {
        
        contentView(data: viewModel.data)
    }
    
    @ViewBuilder
    func contentView(data: SummaryViewModel.Data?) -> some View {
        
        if let data {
            HStack {
                KcalRemainingView(progress: data.kcalProgress, kcalRemaining: data.kcalRemaining)
                
                VStack {
                    MacrosView(viewModel: data.carbsViewModel)
                    Spacer()
                    MacrosView(viewModel: data.proteinViewModel)
                    Spacer()
                    MacrosView(viewModel: data.fatsViewModel)
                }
                .padding([.leading], 16)
            }
        }
    }
}

private struct KcalRemainingView: View {
    
    let progress: Double
    let kcalRemaining: String
    
    var body: some View {
        ZStack {
            CircularProgressView(progress: progress)
                        .frame(width: 150, height: 150)
            
            VStack {
                Text(kcalRemaining)
                Text("Remaining")
            }
        }
    }
}

#Preview {
    
    let goals = Goals(kcal: 200, carbs: 200, protein: 200, fats: 50)
    
    let viewModel = SummaryViewModel(goals: goals)
    
    SummaryView(viewModel: viewModel)
}
