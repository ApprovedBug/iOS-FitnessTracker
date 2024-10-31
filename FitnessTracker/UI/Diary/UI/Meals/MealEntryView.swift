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
        ZStack {
            
            Color.clear
                .contentShape(Rectangle())
            
            VStack(alignment: .leading) {
            
                Divider()
                
                VStack(alignment: .leading) {
                    HStack(alignment: .bottom, spacing: 0) {
                        
                        Text(viewModel.name)
                            .font(.body)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        if !viewModel.isExpanded {
                            Spacer()
                            
                            Text("\(viewModel.kcal)")
                                .font(.body)
                            Text("Kcal")
                                .font(.footnote)
                                .padding([.trailing], 12)
                        }
                        
                        Image(systemName: viewModel.isExpanded ? "chevron.up" : "chevron.down")
                    }
                    if viewModel.isExpanded {
                        detailsView()
                            .padding([.top], 12)
                    }
                }
                .padding([.top, .bottom], 12)
            }
            .frame(maxWidth: .infinity)
            .animation(.easeOut(duration: 0.2), value: viewModel.isExpanded)
        }
        .onTapGesture {
            viewModel.toggleExpanded()
        }
    }
    
    func detailsView() -> some View {
        
        HStack {
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
}

#Preview {
    let foodItem = FoodItem(name: "Apple", kcal: 100, carbs: 20, protein: 10, fats: 5)
    let diaryEntry = DiaryEntry(timestamp: .now, foodItem: foodItem, meal: .breakfast)
    let viewModel = MealEntryViewModel(diaryEntry: diaryEntry)
    MealEntryView(viewModel: viewModel)
}
