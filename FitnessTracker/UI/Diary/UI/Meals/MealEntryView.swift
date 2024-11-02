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
                        
                        Divider()
                    
                        actionsView()
                            .padding([.top], 4)
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
                Text(viewModel.measurement)
                    .font(.footnote)
            }
            .frame(maxWidth: .infinity)
            
            Divider()
            
            VStack(alignment: .center) {
                Text(viewModel.kcal)
                    .font(.body)
                Text("Kcal")
                    .font(.footnote)
            }
            .frame(maxWidth: .infinity)
            
            Divider()
            
            VStack(alignment: .center) {
                Text(viewModel.carbs)
                    .font(.body)
                Text("Carbs")
                    .font(.footnote)
            }
            .frame(maxWidth: .infinity)
            
            Divider()
            
            VStack(alignment: .center) {
                Text(viewModel.protein)
                    .font(.body)
                Text("Proteins")
                    .font(.footnote)
            }
            .frame(maxWidth: .infinity)
            
            Divider()
            
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
            
            Button(action: { viewModel.editDiaryEntryTapped() }) {
                Image(systemName: "pencil")
                    .tint(.blue)
            }
            
            Spacer()
            
            Divider()
            
            Spacer()
            
            Button(action: { viewModel.removeDiaryEntryTapped() }) {
                Image(systemName: "trash")
                    .tint(.red)
            }
            
            Spacer()
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
        quantity: 100
    )
    
    let diaryEntry = DiaryEntry(
        timestamp: .now,
        foodItem: foodItem,
        meal: .breakfast
    )
    
    let viewModel = MealEntryViewModel(
        diaryEntry: diaryEntry,
        eventHandler: MealEntryViewModel.EventHandler(removeEntryTapped: { _ in })
    )
    
    ScrollView {
        MealEntryView(viewModel: viewModel)
            .padding()
    }
}
