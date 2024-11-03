//
//  AddFoodItemViewModel.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 02/08/2024.
//

import DependencyManagement
import Foundation
import FitnessPersistence

@Observable
class AddFoodItemViewModel: Identifiable {
    
    struct EventHandler {
        var didCreateFoodItem: (FoodItem) -> Void
    }
    
    enum State {
        case edit
        case create
    }
    
    var selectedUnit: MeasurementUnit = .grams
    var servingSize: String = ""
    var name: String = ""
    var kcal: String = ""
    var carbs: String = ""
    var protein: String = ""
    var fat: String = ""
    var state: State = .create
    var servings: String = "1"
    
    var isValid: Bool {
        !name.isEmpty &&
        Double(kcal) != nil &&
        Double(carbs) != nil &&
        Double(protein) != nil &&
        Double(fat) != nil &&
        Double(servingSize) != nil
    }
    
    @ObservationIgnored
    @Inject var foodItemRepository: FoodItemRepository
    
    @ObservationIgnored
    let eventHandler: EventHandler
    
    @ObservationIgnored
    let foodItem: FoodItem?
    
    init(eventHandler: EventHandler, foodItem: FoodItem? = nil) {
        self.eventHandler = eventHandler
        self.foodItem = foodItem
        
        if let foodItem {
            populate(with: foodItem)
            state = .edit
        }
    }
    
    func populate(with foodItem: FoodItem) {
        self.name = foodItem.name
        self.kcal = String(foodItem.kcal)
        self.carbs = String(foodItem.carbs)
        self.protein = String(foodItem.protein)
        self.fat = String(foodItem.fats)
        self.servingSize = String(foodItem.servingSize)
        self.selectedUnit = foodItem.measurementUnit
    }
    
    func createFoodItem() {
        guard isValid,
              let kcal = Int(kcal),
              let carbs = Double(carbs),
              let protein = Double(protein),
              let fat = Double(fat),
              let servingSize = Int(servingSize) else {
            return
        }
        
        let foodItem = FoodItem(
            name: name,
            kcal: kcal,
            carbs: carbs,
            protein: protein,
            fats: fat,
            measurementUnit: selectedUnit,
            servingSize: servingSize
        )
        foodItemRepository.saveFoodItem(foodItem)
        eventHandler.didCreateFoodItem(foodItem)
    }
}
