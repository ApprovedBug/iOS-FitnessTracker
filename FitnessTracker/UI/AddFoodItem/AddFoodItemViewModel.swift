//
//  AddFoodItemViewModel.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 02/08/2024.
//

import Combine
import DependencyManagement
import Foundation
import FitnessPersistence

@Observable
class AddFoodItemViewModel: Identifiable {
    
    struct EventHandler {
        var didCreateFoodItem: (FoodItem) -> Void
        var saveEntry: (FoodItem, Double) -> Void
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
        Int(servingSize) != nil &&
        Double(servings) != nil
    }
    
    @ObservationIgnored
    @Inject var foodItemRepository: FoodItemRepository
    
    @ObservationIgnored
    let eventHandler: EventHandler
    
    @ObservationIgnored
    let foodItem: FoodItem?
    
    @ObservationIgnored
    var cancellables: Set<AnyCancellable> = []
    
    init(
        eventHandler: EventHandler,
        foodItem: FoodItem? = nil,
        servings: Double? = nil
    ) {
        self.eventHandler = eventHandler
        self.foodItem = foodItem
        
        if let foodItem {
            populate(with: foodItem, servings: servings ?? 1)
            state = .edit
        }
    }
    
    func populate(with foodItem: FoodItem, servings: Double) {
        self.name = foodItem.name
        self.kcal = String(Int(Double(foodItem.kcal) * servings))
        self.carbs = String(format: "%.1f", foodItem.carbs * servings)
        self.protein = String(format: "%.1f", foodItem.protein * servings)
        self.fat = String(format: "%.1f", foodItem.fats * servings)
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
    
    func saveEntry() {
        guard isValid,
                let foodItem,
                let servings = Double(servings) else {
            return
        }
        eventHandler.saveEntry(foodItem, servings)
    }
    
    func updateBasedOnServings(_ servings: String) {
        
        guard let foodItem else {
            return
        }
        
        let servings = Double(servings) ?? 0
        
        populate(with: foodItem, servings: servings)
    }
}
