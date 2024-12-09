//
//  MealItemView.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 17/11/2023.
//

import FitnessPersistence
import FitnessUI
import Foundation
import SwiftUI

struct MealEntryHeaderView: View {
    
    @Bindable var viewModel: MealEntryHeaderViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
        
            HStack {
                
                Text(viewModel.mealTitle)
                    .font(.body)
                    .foregroundColor(.primary)
                
                Spacer()
                
                HStack(spacing: 12) {
                    mealItemMacrosView(amount: viewModel.kcalConsumed, macro: "Kcal")
                    
                    Divider()
                    
                    mealItemMacrosView(amount: viewModel.carbsConsumed, macro: "Carbs")
                    
                    Divider()
                    
                    mealItemMacrosView(amount: viewModel.proteinsConsumed, macro: "Protein")
                    
                    Divider()
                    
                    mealItemMacrosView(amount: viewModel.fatsConsumed, macro: "Fat")
                }
                .padding(.trailing, 8)
                
                Button {
                    Task {
                        await viewModel.saveMealTapped()
                    }
                } label: {
                    Image(systemName: "bookmark")
                        .padding()
                        .font(.headline)
                        .foregroundColor(.blue)
                }
            }
        }
        .padding(.horizontal, 12)
    }
    
    func mealItemMacrosView(
        amount: String,
        macro: String
    ) -> some View {
        VStack {
            Text(amount)
                .font(.footnote)
                .foregroundColor(.secondary)
            
            Text(macro)
                .font(.footnote)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    
    let foodItem = FoodItem(
        name: "Fat Free Greek Yoghurt",
        brand: "Morrisons",
        kcal: 66,
        carbs: 6,
        protein: 9.8,
        fats: 0.3,
        measurementUnit: .grams,
        servingSize: 100
    )
    
    let diaryEntry = DiaryEntry(
        timestamp: .now,
        foodItem: foodItem,
        mealType: .breakfast,
        servings: 2
    )
    
    let diaryEntry2 = DiaryEntry(
        timestamp: .now,
        foodItem: foodItem,
        mealType: .breakfast,
        servings: 2
    )
    
    let viewModel = MealEntryHeaderViewModel(
        mealType: .breakfast,
        entries: [diaryEntry, diaryEntry2],
        eventHandler: nil
    )
    
    ScrollView {
        MealEntryHeaderView(viewModel: viewModel)
    }
}
