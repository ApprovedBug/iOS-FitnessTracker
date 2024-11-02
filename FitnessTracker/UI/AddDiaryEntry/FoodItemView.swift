//
//  FoodItemView.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 31/10/2024.
//

import FitnessPersistence
import FitnessUI
import SwiftUI

struct FoodItemView: View {
    
    @Bindable var viewModel: FoodItemViewModel
    
    var body: some View {
        
        CardView {
            VStack(alignment: .center, spacing: 16) {
                Text(viewModel.name)
                    .font(.headline)
                
                HStack(alignment: .top) {
                    VStack(alignment: .center) {
                        Text("\(viewModel.kcal)")
                            .font(.body)
                        Text("Kcal")
                            .font(.footnote)
                    }
                    .frame(maxWidth: .infinity)
                    VStack(alignment: .center) {
                        Text("\(viewModel.carbs)")
                            .font(.body)
                        Text("Carbs")
                            .font(.footnote)
                    }
                    .frame(maxWidth: .infinity)
                    VStack(alignment: .center) {
                        Text("\(viewModel.protein)")
                            .font(.body)
                        Text("Protein")
                            .font(.footnote)
                    }
                    .frame(maxWidth: .infinity)
                    VStack(alignment: .center) {
                        Text("\(viewModel.fat)")
                            .font(.body)
                        Text("Fats")
                            .font(.footnote)
                    }
                    .frame(maxWidth: .infinity)
                    VStack(alignment: .center) {
                        Text("\(viewModel.fat)")
                            .font(.body)
                        Text("Fats")
                            .font(.footnote)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
    }
}

#Preview {
    let foodItem = FoodItem(
        name: "Frozen Raspberries",
        kcal: 8,
        carbs: 1.1,
        protein: 0,
        fats: 0.1,
        measurementUnit: .grams,
        quantity: 25
    )
    let viewModel = FoodItemViewModel(foodItem: foodItem)
    
    ScrollView {
        FoodItemView(viewModel: viewModel)
    }
}
