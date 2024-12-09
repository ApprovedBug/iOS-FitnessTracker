//
//  MealItemView.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 07/11/2024.
//

import FitnessPersistence
import FitnessUI
import Foundation
import SwiftUI

struct MealItemView: View {
    
    @Bindable var viewModel: MealItemViewModel
    
    var body: some View {
        
        CardView {
            VStack {
                HStack {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(alignment: .bottom) {
                            Text(viewModel.name)
                                .font(.headline)
                            
                            Spacer()
                        }
                        
                        HStack(alignment: .bottom) {
                            Text("\(viewModel.kcal)kcal")
                                .font(.footnote)
                                .padding([.trailing], 12)
                            
                            Text("\(viewModel.carbs)g carbs")
                                .font(.footnote)
                                .padding([.trailing], 12)
                            
                            Text("\(viewModel.proteins)g protein")
                                .font(.footnote)
                                .padding([.trailing], 12)
                            
                            Text("\(viewModel.fats)g fat")
                                .font(.footnote)
                                .padding([.trailing], 12)
                        }
                    }
                    
                    AnimatedCheckmarkButton {
                        await viewModel.addItemTapped()
                    }
                }
                
                if viewModel.isExpanded {
                    Divider()
                        .padding([.top], 12)
                    
                    actionsView()
                        .padding([.top], 12)
                }
            }
        }
        .animation(.easeOut(duration: 0.15), value: viewModel.isExpanded)
        .onTapGesture {
            viewModel.toggleExpanded()
        }
        .fullScreenCover(isPresented: $viewModel.isShowingEditMeal) {
            MealDetailsView(viewModel: MealDetailsViewModel(meal: viewModel.meal))
        }
    }
    
    func actionsView() -> some View {
        HStack {
            Spacer()
            
            Button(action: { viewModel.editMealTapped() }) {
                Image(systemName: "pencil")
                    .tint(.blue)
            }
            
            Spacer()
            
            Divider()
            
            Spacer()
            
            Button(action: { viewModel.deleteMealTapped() }) {
                Image(systemName: "trash")
                    .tint(.red)
            }
            
            Spacer()
        }
    }
}

#Preview {
    let raspberries = FoodItem(
        name: "Frozen Raspberries",
        brand: "Morrisons",
        kcal: 8,
        carbs: 1.1,
        protein: 0,
        fats: 0.1,
        measurementUnit: .grams,
        servingSize: 25
    )
    
    let mealFoodItem = MealFoodItem(servings: 4, foodItem: raspberries)
    
    let meal = Meal(name: "Yoghurt Bowl", foodItems: [mealFoodItem])
    
    let eventHandler = MealItemViewModel.EventHandler(
        addMealTapped: { item in
        print("Add Meal: \(meal)")
    }, deleteMealTapped: { item in
        print("Delete Meal: \(meal)")
    })
    
    let viewModel = MealItemViewModel(
        meal: meal,
        eventHandler: eventHandler
    )
    
    ScrollView {
        MealItemView(viewModel: viewModel)
    }
}
