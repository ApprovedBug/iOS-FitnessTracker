//
//  MealItemView.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 17/11/2023.
//

import Foundation
import SwiftUI

struct MealItemView: View {
    
    var viewModel: MealItemViewModel
    
    var body: some View {
        
        switch viewModel.state {
            case .idle:
                EmptyView()
            case .ready(let data):
                CardView {
                    ContentView(data: data)
                }
        }
    }
}

private struct ContentView: View {
    
    let data: MealItemViewModel.Data
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 16) {
            
            HStack {
                Spacer()
                
                Text(data.mealTitle)
                
                Spacer()
                
                Image(systemName: "plus.circle")
                    .font(.headline)
                    .foregroundColor(.blue)
            }
            
            HStack {
                
                MacrosView(amount: data.kcalConsumed, macro: "kcal")
                    .frame(maxWidth: .infinity)
                
                Divider()
                
                MacrosView(amount: data.carbsConsumed, macro: "Carbs")
                    .frame(maxWidth: .infinity)
                
                Divider()
                
                MacrosView(amount: data.proteinsConsumed, macro: "Proteins")
                    .frame(maxWidth: .infinity)
                
                Divider()
                
                MacrosView(amount: data.fatsConsumed, macro: "Fats")
                    .frame(maxWidth: .infinity)
            }
        }
    }
}

private struct MacrosView: View {
    
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
