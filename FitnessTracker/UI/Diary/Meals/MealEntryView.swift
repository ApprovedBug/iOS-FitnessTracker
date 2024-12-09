//
//  MealEntryView.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 31/10/2024.
//

import FitnessPersistence
import SwiftUI

struct MealEntryView: View {
    
    @Bindable var viewModel: MealEntryViewModel
    
    var body: some View {
        ZStack {
            
            Color.clear
                .contentShape(Rectangle())
            
            VStack(alignment: .leading, spacing: 0) {
                
                VStack(alignment: .leading) {
                    HStack(alignment: .bottom, spacing: 0) {
                        
                        Text(viewModel.name)
                            .font(.body)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        if !viewModel.isExpanded {
                            Spacer()
                            
                            Text("\(viewModel.kcal)")
                                .font(.footnote)
                                .foregroundColor(.secondary)
                            Text("Kcal")
                                .font(.footnote)
                                .foregroundColor(.secondary)
                                .padding([.trailing], 12)
                        }
                        
                        Image(systemName: viewModel.isExpanded ? "chevron.up" : "chevron.down")
                            .foregroundColor(.secondary)
                            .padding([.bottom], 4)
                    }
                    .padding([.vertical], 12)
                    
                    if viewModel.isExpanded {
                        detailsView()
                            .padding([.bottom], 12)
                            .animation(.default, value: viewModel.isExpanded)
                    }
                    
                }
                .padding([.horizontal], 12)
            }
            .frame(maxWidth: .infinity)
        }
        .onTapGesture {
            viewModel.toggleExpanded()
        }
    }
    
    func detailsView() -> some View {
        
        HStack {
            VStack(alignment: .center) {
                Text(viewModel.servingSize)
                    .font(.footnote)
                    .foregroundColor(.secondary)
                Text(viewModel.measurement)
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
            
            Divider()
            
            VStack(alignment: .center) {
                Text(viewModel.kcal)
                    .font(.footnote)
                    .foregroundColor(.secondary)
                Text("Kcal")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
            
            Divider()
            
            VStack(alignment: .center) {
                Text(viewModel.carbs)
                    .font(.footnote)
                    .foregroundColor(.secondary)
                Text("Carbs")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
            
            Divider()
            
            VStack(alignment: .center) {
                Text(viewModel.protein)
                    .font(.footnote)
                    .foregroundColor(.secondary)
                Text("Protein")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
            
            Divider()
            
            VStack(alignment: .center) {
                Text(viewModel.fat)
                    .font(.footnote)
                    .foregroundColor(.secondary)
                Text("Fat")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    let foodItem = FoodItem(
        name: "Fat Free Greek Yoghurt",
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
    
    let viewModel = MealEntryViewModel(
        diaryEntry: diaryEntry
    )
    
    ScrollView {
        MealEntryView(viewModel: viewModel)
            .padding()
    }
}
