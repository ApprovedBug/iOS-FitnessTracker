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
@MainActor
class AddFoodItemViewModel: Identifiable {
    
    struct EventHandler {
        var didCreateFoodItem: @MainActor (FoodItem) async -> Void
        var saveEntry: @MainActor (FoodItem, Double) async -> Void
    }
    
    enum State {
        case edit
        case create
    }
    
    var selectedUnit: MeasurementUnit = .grams
    var servingSize: String = ""
    var name: String = ""
    var brand: String = ""
    var kcal: String = ""
    var carbs: String = ""
    var protein: String = ""
    var fat: String = ""
    var state: State = .create
    var servings: String = "1"
    
    var isValid: Bool {
        !name.isEmpty &&
        !brand.isEmpty &&
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
            let defaultServings = servings ?? 1
            if floor(defaultServings) == defaultServings {
                self.servings = String(format: "%.0f", defaultServings)
            } else {
                self.servings = String(format: "%.1f", defaultServings)
            }

            populate(with: foodItem, servings: defaultServings)
            state = .edit
        }
    }
    
    func populate(with foodItem: FoodItem, servings: Double) {
        self.name = foodItem.name
        self.brand = foodItem.brand
        self.kcal = String(Int(Double(foodItem.kcal) * servings))
        self.carbs = String(format: "%.1f", foodItem.carbs * servings)
        self.protein = String(format: "%.1f", foodItem.protein * servings)
        self.fat = String(format: "%.1f", foodItem.fats * servings)
        self.servingSize = String(foodItem.servingSize)
        self.selectedUnit = foodItem.measurementUnit
    }
    
    func createFoodItem() async {
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
            brand: brand,
            kcal: kcal,
            carbs: carbs,
            protein: protein,
            fats: fat,
            measurementUnit: selectedUnit,
            servingSize: servingSize
        )
        await foodItemRepository.saveFoodItem(foodItem)
        await eventHandler.didCreateFoodItem(foodItem)
    }
    
    func saveEntry() async {
        guard isValid,
                let foodItem,
                let servings = Double(servings) else {
            return
        }
        await eventHandler.saveEntry(foodItem, servings)
    }
    
    func updateBasedOnServings(_ servings: String) {
        
        guard let foodItem else {
            return
        }
        
        let servings = Double(servings) ?? 0
        
        populate(with: foodItem, servings: servings)
    }
}
