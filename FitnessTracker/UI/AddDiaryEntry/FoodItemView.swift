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
            HStack {
                VStack(alignment: .leading, spacing: 12) {
                    HStack(alignment: .bottom) {
                        Text(viewModel.name)
                            .font(.headline)
                        
                        Text("\(viewModel.servingSize)\(viewModel.measurementUnit)")
                            .font(.footnote)
                            .padding([.bottom], 1)
                        
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
                
                Button {
                    viewModel.addItemTapped()
                } label: {
                    Image(systemName: "plus.circle")
                        .font(.headline)
                        .foregroundColor(.blue)
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
        servingSize: 25
    )
    
    let eventHandler = FoodItemViewModel.EventHandler { item in
        print(item)
    }
    
    let viewModel = FoodItemViewModel(
        foodItem: foodItem,
        eventHandler: eventHandler
    )
    
    ScrollView {
        FoodItemView(viewModel: viewModel)
    }
}
