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
                                .padding([.bottom], 1)
                        }
                        
                        Image(systemName: viewModel.isExpanded ? "chevron.up" : "chevron.down")
                            .padding([.bottom], 4)
                    }
                    if viewModel.isExpanded {
                        detailsView()
                            .padding([.top], 12)
                        
                        actionsView()
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
            VStack(alignment: .center) {
                Text(viewModel.quantity)
                    .font(.body)
                Text(viewModel.measurement.localizedCapitalized)
                    .font(.footnote)
            }
            .frame(maxWidth: .infinity)
            
            VStack(alignment: .center) {
                Text(viewModel.kcal)
                    .font(.body)
                Text("Kcal")
                    .font(.footnote)
            }
            .frame(maxWidth: .infinity)
            
            VStack(alignment: .center) {
                Text(viewModel.carbs)
                    .font(.body)
                Text("Carbs")
                    .font(.footnote)
            }
            .frame(maxWidth: .infinity)
            
            VStack(alignment: .center) {
                Text(viewModel.protein)
                    .font(.body)
                Text("Protein")
                    .font(.footnote)
            }
            .frame(maxWidth: .infinity)
            
            VStack(alignment: .center) {
                Text(viewModel.fat)
                    .font(.body)
                Text("Fats")
                    .font(.footnote)
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    func actionsView() -> some View {
        HStack {
            Spacer()
            Button(action: { viewModel.removeDiaryEntryTapped() }) {
                Image(systemName: "trash")
                    .tint(.red)
            }
        }
    }
}

#Preview {
    let foodItem = FoodItem(name: "Apple", kcal: 100, carbs: 20, protein: 10, fats: 5, measurementUnit: .item, quantity: 1)
    let diaryEntry = DiaryEntry(timestamp: .now, foodItem: foodItem, meal: .breakfast)
    let viewModel = MealEntryViewModel(
        diaryEntry: diaryEntry,
        eventHandler: MealEntryViewModel.EventHandler(removeEntryTapped: { _ in })
    )
    MealEntryView(viewModel: viewModel)
}
