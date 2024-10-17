//
//  AddDiaryEntryView.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 02/08/2024.
//

import Foundation
import SwiftUI

struct AddDiaryEntryView: View {
    
    @Bindable var viewModel: AddDiaryEntryViewModel
    
    var body: some View {
        
        Button("Create new food item") {
            viewModel.createFoodItemTapped()
        }
        .sheet(isPresented: $viewModel.isCreateFoodItemOpen) {
            AddFoodItemView(viewModel: AddFoodItemViewModel())
        }
    }
}
