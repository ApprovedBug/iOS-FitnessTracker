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
                    TextField("Name", text: $viewModel.name)
                }
                
                Section(header: Text("Serving Info")) {
                    
                    Picker("Unit", selection: $viewModel.selectedUnit) {
                        ForEach(MeasurementUnit.allCases, id: \.self) { unit in
                            Text(unit.rawValue).tag(unit)
                        }
                    }
                    TextField("Serving Size", text: $viewModel.servingSize)
                        .keyboardType(.decimalPad)
                }
                
                Section(header: Text("Nutritional Information")) {
                    
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
            .navigationBarTitle("Create Food Item", displayMode: .inline)
            .navigationBarItems(trailing: Button("Save") {
                viewModel.createFoodItem()
                presentationMode.wrappedValue.dismiss()
            }.disabled(!viewModel.isValid))
        }
    }
    
    func editView() -> some View {
        
        NavigationView {
            VStack(alignment: .leading, spacing: 12) {
                Text(viewModel.name)
                
                Divider()
                
                HStack(spacing: 0) {
                    Text("Serving Size")
                    
                    Spacer()
                    
                    Text("\(viewModel.servingSize)")
                        .padding(.trailing, viewModel.selectedUnit == .item ? 2 : 0)
                        .font(.footnote)
                    
                    Text("\(viewModel.selectedUnit.rawValue)")
                        .font(.footnote)
                }
                
                Divider()
                
                HStack {
                    Text("Servings")
                    
                    Spacer()
                    
                    TextField("", text: $viewModel.servings)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(.roundedBorder)
                        .multilineTextAlignment(.trailing)
                        .frame(maxWidth: 60)
                        .onChange(of: viewModel.servings) { oldValue, newValue in
                            viewModel.updateBasedOnServings(newValue)
                        }
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
            .navigationBarTitle("Add Item", displayMode: .inline)
            .navigationBarItems(trailing: Button("Save") {
                viewModel.saveEntry()
                presentationMode.wrappedValue.dismiss()
            }.disabled(!viewModel.isValid))
            .padding()
        }
    }
}

#Preview("Create mode") {
    DependencyContainer.register(ContextProviding.self) {
        PersistenceManager()
    }
    
    DependencyContainer.register(FoodItemRepository.self) {
        LocalFoodItemRepository()
    }
    
    let eventHandler = AddFoodItemViewModel.EventHandler(
        didCreateFoodItem: { _ in },
        saveEntry: { (_, _) in }
    )
    
    let viewModel = AddFoodItemViewModel(eventHandler: eventHandler)
    
    return AddFoodItemView(viewModel: viewModel)
}

#Preview("Add mode") {
    DependencyContainer.register(ContextProviding.self) {
        PersistenceManager()
    }
    
    DependencyContainer.register(FoodItemRepository.self) {
        LocalFoodItemRepository()
    }
    
    let eventHandler = AddFoodItemViewModel.EventHandler(
        didCreateFoodItem: { _ in },
        saveEntry: { (_, _) in }
    )
    
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
