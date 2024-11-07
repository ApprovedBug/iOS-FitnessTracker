//
//  MealItemView.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 07/11/2024.
//

import FitnessUI
import Foundation
import SwiftUI

struct MealItemView: View {
    
    @Bindable var viewModel: MealItemViewModel
    
    var body: some View {
        
        CardView {
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

//#Preview {
//    let foodItem = FoodItem(
//        name: "Frozen Raspberries",
//        kcal: 8,
//        carbs: 1.1,
//        protein: 0,
//        fats: 0.1,
//        measurementUnit: .grams,
//        servingSize: 25
//    )
//    
//    let eventHandler = MealItemViewModel.EventHandler { item in
//        print(item)
//    }
//    
//    let viewModel = MealItemViewModel(
//        foodItem: foodItem,
//        eventHandler: eventHandler
//    )
//    
//    ScrollView {
//        FoodItemView(viewModel: viewModel)
//    }
//}

