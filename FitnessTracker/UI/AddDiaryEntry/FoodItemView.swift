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
            VStack(alignment: .leading) {
                Text(viewModel.name)
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        Text("\(viewModel.kcal)")
                            .font(.body)
                        Text("Kcal")
                            .font(.footnote)
                    }
                    VStack(alignment: .leading) {
                        Text("\(viewModel.carbs)")
                            .font(.body)
                        Text("Carbs")
                            .font(.footnote)
                    }
                    VStack(alignment: .leading) {
                        Text("\(viewModel.protein)")
                            .font(.body)
                        Text("Protein")
                            .font(.footnote)
                    }
                    VStack(alignment: .leading) {
                        Text("\(viewModel.fat)")
                            .font(.body)
                        Text("Fats")
                            .font(.footnote)
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    let foodItem = FoodItem(
        name: "Cheese",
        kcal: 100,
        carbs: 10,
        protein: 10,
        fats: 20
    )
    let viewModel = FoodItemViewModel(foodItem: foodItem)
    
    FoodItemView(viewModel: viewModel)
}
