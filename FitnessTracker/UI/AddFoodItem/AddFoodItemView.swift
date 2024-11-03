//
//  AddFoodItemView.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 02/08/2024.
//

import DependencyManagement
import FitnessPersistence
import FitnessUI
import Foundation
import SwiftUI

struct AddFoodItemView: View {
    @Bindable var viewModel: AddFoodItemViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        switch viewModel.state {
            case .create:
                createView()
            case .edit:
                editView()
        }
    }
    
    func createView() -> some View {
        
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
                    TextField("Quantity", text: $viewModel.servingSize)
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
    
    func editView() -> some View {
        
        VStack(alignment: .leading, spacing: 12) {
            Text(viewModel.name)
            
            Divider()
            
            HStack {
                Text("Serving Size")
                
                Spacer()
                
                Text("\(viewModel.servingSize)\(viewModel.selectedUnit.rawValue)")
                    .font(.footnote)
            }
            
            Divider()
            
            HStack {
                Text("Servings")
                
                Spacer()
                
                TextField("Servings", text: $viewModel.servings)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(.roundedBorder)
                    .multilineTextAlignment(.trailing)
                    .frame(maxWidth: 60)
            }
            
            Divider()
            
            HStack(alignment: .bottom) {
                Text("\(viewModel.kcal)kcal")
                    .font(.footnote)
                
                Spacer()
                
                Text("\(viewModel.carbs)g carbs")
                    .font(.footnote)
                
                Spacer()
                
                Text("\(viewModel.protein)g protein")
                    .font(.footnote)
                
                Spacer()
                
                Text("\(viewModel.fat)g fat")
                    .font(.footnote)
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
    }
}

#Preview("Create mode") {
    DependencyContainer.register(ContextProviding.self) {
        PersistenceManager()
    }
    
    DependencyContainer.register(FoodItemRepository.self) { LocalFoodItemRepository()
    }
    
    let eventHandler = AddFoodItemViewModel.EventHandler { item in }
    
    let viewModel = AddFoodItemViewModel(eventHandler: eventHandler)
    
    return AddFoodItemView(viewModel: viewModel)
}

#Preview("Add mode") {
    DependencyContainer.register(ContextProviding.self) {
        PersistenceManager()
    }
    
    DependencyContainer.register(FoodItemRepository.self) { LocalFoodItemRepository()
    }
    
    let eventHandler = AddFoodItemViewModel.EventHandler { item in }
    
    let foodItem = FoodItem(
        name: "Fat Free Greek Yoghurt",
        kcal: 66,
        carbs: 6,
        protein: 9.8,
        fats: 0.3,
        measurementUnit: .grams,
        servingSize: 100
    )
    
    let viewModel = AddFoodItemViewModel(
        eventHandler: eventHandler,
        foodItem: foodItem
    )
    
    return ScrollView {
        AddFoodItemView(viewModel: viewModel)
    }
}
