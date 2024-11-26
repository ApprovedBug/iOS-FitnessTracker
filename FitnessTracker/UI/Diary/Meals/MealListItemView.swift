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

struct MealListItemView: View {
    
    @Bindable var viewModel: MealListItemViewModel
    
    var body: some View {
        
        switch viewModel.state {
            case .idle:
                EmptyView()
            case .ready(let data):
                CardView {
                    contentView(data: data)
                }
                .animation(.easeOut(duration: 0.15))
        }
    }
    
    func contentView(data: MealListItemViewModel.Data) -> some View {
        
        VStack(alignment: .center, spacing: 12) {
            
            HStack {
                Spacer()
                
                Text(data.mealTitle)
                    .padding([.leading], 20)
                
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
                
                mealItemMacrosView(amount: data.kcalConsumed, macro: "Kcal")
                    .frame(maxWidth: .infinity)
                
                Divider()
                
                mealItemMacrosView(amount: data.carbsConsumed, macro: "Carbs")
                    .frame(maxWidth: .infinity)
                
                Divider()
                
                mealItemMacrosView(amount: data.proteinsConsumed, macro: "Protein")
                    .frame(maxWidth: .infinity)
                
                Divider()
                
                mealItemMacrosView(amount: data.fatsConsumed, macro: "Fat")
                    .frame(maxWidth: .infinity)
            }
            
            ForEach(data.entries) { entry in
                MealEntryView(viewModel: entry)
            }
            
            if data.entries.count > 1 {
                Divider()
                
                saveMealView()
            }
        }
    }
    
    func mealItemMacrosView(
        amount: String,
        macro: String
    ) -> some View {
        VStack {
            Text(amount)
                .font(.body)
            Text(macro)
                .font(.footnote)
        }
    }
    
    func saveMealView() -> some View {
        Button("Save Meal") {
            Task {
                await viewModel.saveMealTapped()
            }
        }
        .buttonStyle(TertiaryButtonStyle())
        .frame(height: 32)
        .sheet(isPresented: $viewModel.isShowingSaveMealAlert) {
            VStack(alignment: .leading, spacing: 16) {
                Text("Save meal")
                    .font(.title)
                Text("Saving meals makes it easier to add commonly tracked foods to your diary.")
                TextField("Enter Meal Name i.e. Scrambled eggs on toast", text: $viewModel.mealName)
                    .textFieldStyle(.roundedBorder)
                    .font(.body)
                    .multilineTextAlignment(.leading)
                Spacer()
                Button("Save Meal") {
                    Task {
                        await viewModel.saveMealTapped()
                    }
                }
                .buttonStyle(RoundedButtonStyle())
                .disabled(!viewModel.mealNameValid)
                
            }
            .padding()
            .presentationDetents([.small])
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
    
    let diaryEntry2 = DiaryEntry(
        timestamp: .now,
        foodItem: foodItem,
        mealType: .breakfast,
        servings: 2
    )
    
    let viewModel = MealListItemViewModel(
        mealType: .breakfast,
        entries: [diaryEntry, diaryEntry2]
    )
    
    ScrollView {
        MealListItemView(viewModel: viewModel)
    }
}
