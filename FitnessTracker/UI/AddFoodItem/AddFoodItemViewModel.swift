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
class AddFoodItemViewModel {
    var name: String = ""
    var kcal: String = ""
    var carbs: String = ""
    var protein: String = ""
    var fat: String = ""
    
    var isValid: Bool {
        !name.isEmpty &&
        Double(kcal) != nil &&
        Double(carbs) != nil &&
        Double(protein) != nil &&
        Double(fat) != nil
    }
    
    @ObservationIgnored
    @Inject var foodItemRepository: FoodItemRepository
    
    func createFoodItem() {
        guard isValid,
              let kcal = Int(kcal),
              let carbs = Double(carbs),
              let protein = Double(protein),
              let fat = Double(fat) else {
            return
        }
        
        let foodItem = FoodItem(name: name, kcal: kcal, carbs: carbs, protein: protein, fats: fat)
        foodItemRepository.saveFoodItem(foodItem)
    }
}
