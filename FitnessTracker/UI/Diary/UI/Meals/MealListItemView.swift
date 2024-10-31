//
//  MealItemView.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 17/11/2023.
//

import FitnessUI
import Foundation
import SwiftUI

struct MealListItemView: View {
    
    var viewModel: MealListItemViewModel
    
    var body: some View {
        
        switch viewModel.state {
            case .idle:
                EmptyView()
            case .ready(let data):
                CardView {
                    ContentView(viewModel: viewModel, data: data)
                }
        }
    }
}

private struct ContentView: View {
    
    @Bindable var viewModel: MealListItemViewModel
    let data: MealListItemViewModel.Data
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 16) {
            
            HStack {
                Text(data.mealTitle)
                
                Spacer()
                
                Button {
                    viewModel.addEntryTapped()
                } label: {
                    Image(systemName: "plus.circle")
                        .font(.headline)
                        .foregroundColor(.blue)
                }
            }
            
            HStack {
                
                MealItemMacrosView(amount: data.kcalConsumed, macro: "kcal")
                    .frame(maxWidth: .infinity)
                
                Divider()
                
                MealItemMacrosView(amount: data.carbsConsumed, macro: "Carbs")
                    .frame(maxWidth: .infinity)
                
                Divider()
                
                MealItemMacrosView(amount: data.proteinsConsumed, macro: "Proteins")
                    .frame(maxWidth: .infinity)
                
                Divider()
                
                MealItemMacrosView(amount: data.fatsConsumed, macro: "Fats")
                    .frame(maxWidth: .infinity)
            }
            
            ForEach(data.entries) { entry in
                MealEntryView(viewModel: MealEntryViewModel(diaryEntry: entry))
            }
        }
        .sheet(isPresented: $viewModel.isAddDiaryEntryOpen) {
            AddDiaryEntryView(viewModel: AddDiaryEntryViewModel(meal: viewModel.meal))
        }
    }
}

private struct MealItemMacrosView: View {
    
    let amount: String
    let macro: String
    
    var body: some View {
        
        VStack {
            Text(amount)
                .font(.body)
            Text(macro)
                .font(.footnote)
        }
    }
}

#Preview {
    
    let viewModel = MealListItemViewModel(meal: .breakfast, entries: [])
    MealListItemView(viewModel: viewModel)
}
