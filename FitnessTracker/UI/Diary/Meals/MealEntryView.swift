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
                            .padding([.top], 12)
                    }
                }
                .padding([.top], 12)
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
                Text("Protein")
                    .font(.footnote)
            }
            .frame(maxWidth: .infinity)
            
            Divider()
            
            VStack(alignment: .center) {
                Text(viewModel.fat)
                    .font(.body)
                Text("Fat")
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
            
            Button(action: { Task { await viewModel.removeDiaryEntryTapped() }}) {
                Image(systemName: "trash")
                    .tint(.red)
            }
            
            Spacer()
        }
        .sheet(isPresented: $viewModel.isShowingEditItem, content: {
            if let addFoodItemViewModel = viewModel.addFoodItemViewModel {
                AddFoodItemView(viewModel: addFoodItemViewModel)
                    .presentationDetents([.small])
            }
        })
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
        diaryEntry: diaryEntry,
        eventHandler: MealEntryViewModel.EventHandler(
            removeEntryTapped: { _ in }, updateEntry: { _, _ in })
    )
    
    ScrollView {
        MealEntryView(viewModel: viewModel)
            .padding()
    }
}
