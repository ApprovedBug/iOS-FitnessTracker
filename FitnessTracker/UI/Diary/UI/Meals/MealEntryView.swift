//
//  MealEntryView.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 31/10/2024.
//

import FitnessPersistence
import SwiftUI

struct MealEntryView: View {
    
    let viewModel: MealEntryViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Divider()
            
            Text(viewModel.name)
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text("Kcal")
                        .font(.footnote)
                    Text("\(viewModel.kcal)")
                        .font(.body)
                }
                .frame(maxWidth: .infinity)
                
                VStack(alignment: .leading) {
                    Text("Carbs")
                        .font(.footnote)
                    Text("\(viewModel.carbs)")
                        .font(.body)
                }
                .frame(maxWidth: .infinity)
                
                VStack(alignment: .leading) {
                    Text("Protein")
                        .font(.footnote)
                    Text("\(viewModel.protein)")
                        .font(.body)
                }
                .frame(maxWidth: .infinity)
                
                VStack(alignment: .leading) {
                    Text("Fats")
                        .font(.footnote)
                    Text("\(viewModel.fat)")
                        .font(.body)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    let foodItem = FoodItem(name: "Apple", kcal: 100, carbs: 20, protein: 10, fats: 5)
    let diaryEntry = DiaryEntry(timestamp: .now, foodItem: foodItem, meal: .breakfast)
    let viewModel = MealEntryViewModel(diaryEntry: diaryEntry)
    MealEntryView(viewModel: viewModel)
}
