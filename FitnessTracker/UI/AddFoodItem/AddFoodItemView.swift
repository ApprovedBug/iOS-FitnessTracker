//
//  AddFoodItemView.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 02/08/2024.
//

import FitnessPersistence
import Foundation
import SwiftUI

struct AddFoodItemView: View {
    @Bindable var viewModel: AddFoodItemViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Food Description")) {
                    TextField("Description", text: $viewModel.name)
                }
                Section(header: Text("Nutritional Information")) {
                    
                    Picker("Unit", selection: $viewModel.selectedUnit) {
                        ForEach(MeasurementUnit.allCases, id: \.self) { unit in
                            Text(unit.rawValue).tag(unit)
                        }
                    }
                    TextField("Quantity", text: $viewModel.quantity)
                        .keyboardType(.decimalPad)
                    TextField("Calories", text: $viewModel.kcal)
                        .keyboardType(.decimalPad)
                    TextField("Carbs", text: $viewModel.carbs)
                        .keyboardType(.decimalPad)
                    TextField("Protein", text: $viewModel.protein)
                        .keyboardType(.decimalPad)
                    TextField("Fat", text: $viewModel.fat)
                        .keyboardType(.decimalPad)
                }
            }
            .navigationBarTitle("New Food Item", displayMode: .inline)
            .navigationBarItems(trailing: Button("Save") {
                viewModel.createFoodItem()
                presentationMode.wrappedValue.dismiss()
            }.disabled(!viewModel.isValid))
        }
    }
}
