//
//  OnboardingViewModel.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 20/11/2023.
//

import ConfigurationManagement
import DependencyManagement
@preconcurrency import FitnessPersistence
import Foundation
import SwiftUI

// Enum for Activity Level
enum ActivityLevel: Double, CaseIterable {
    case sedentary = 1.2
    case lightlyActive = 1.375
    case moderatelyActive = 1.55
    case veryActive = 1.725
    case extremelyActive = 1.9
    
    var description: String {
        switch self {
        case .sedentary: return "Sedentary"
        case .lightlyActive: return "Lightly Active"
        case .moderatelyActive: return "Moderately Active"
        case .veryActive: return "Very Active"
        case .extremelyActive: return "Extremely Active"
        }
    }
}
// Enum for Gender
enum Gender: CaseIterable {
    case male
    case female
    
    var description: String {
        switch self {
        case .male: return "Male"
        case .female: return "Female"
        }
    }
}

// Enum for Weight Goal
enum WeightGoal: CaseIterable {
    case lose1KgPerWeek
    case lose0_5KgPerWeek
    case maintain
    case gain0_5KgPerWeek
    case gain1KgPerWeek
    
    var description: String {
        switch self {
        case .lose1KgPerWeek: return "Lose 1 kg per week"
        case .lose0_5KgPerWeek: return "Lose 0.5 kg per week"
        case .maintain: return "Maintain weight"
        case .gain0_5KgPerWeek: return "Gain 0.5 kg per week"
        case .gain1KgPerWeek: return "Gain 1 kg per week"
        }
    }
}

@Observable
@MainActor
class OnboardingViewModel {
    
    var targetKcal: Int?
    
    var gender: Gender = .male
    var age: String = ""
    var weight: String = ""
    var height: String = ""
    var selectedActivityLevel: ActivityLevel = .sedentary
    var selectedWeightGoal: WeightGoal = .maintain
    var resultText: String = ""
    var showDiaryView = false
    
    @ObservationIgnored
    @Inject
    var goalsRepository: GoalsRepository
    
    @ObservationIgnored
    @Inject
    var appConfigurationManager: AppConfigurationManaging
    
    func continueTapped() async {
        await calculate()
    }
    
    func skipTapped() {
        showDiaryView = true
        appConfigurationManager.setValue(value: true, key: Keys.onboardingCompleted)
    }
    
    func calculate() async {
        guard let age = Double(age),
              let weight = Double(weight),
              let height = Double(height) else {
            resultText = "Invalid input. Please enter valid numbers."
            return
        }
        
        let caloricIntakeForWeightLoss = calculateCaloricIntakeForWeightLoss(
            gender: gender,
            age: age,
            weight: weight,
            height: height,
            activityLevel: selectedActivityLevel.rawValue
        )
        
        let macronutrients = calculateMacronutrients(caloricIntake: caloricIntakeForWeightLoss)
        
        resultText = """
        Results:
        Caloric Intake for Weight Loss: \(caloricIntakeForWeightLoss) calories
        Protein: \(macronutrients.protein) grams
        Carbs: \(macronutrients.carbs) grams
        Fat: \(macronutrients.fat) grams
        """
        
        let goals = Goals(
            kcal: caloricIntakeForWeightLoss,
            carbs: macronutrients.carbs,
            protein: macronutrients.protein,
            fats: macronutrients.fat
        )
        await goalsRepository.saveGoals(goals: goals, for: "something")
        appConfigurationManager.setValue(value: true, key: Keys.onboardingCompleted)
        showDiaryView = true
    }
    
    func calculateCaloricIntakeForWeightLoss(gender: Gender, age: Double, weight: Double, height: Double, activityLevel: Double) -> Int {
        // Calculate BMR using Harris-Benedict equation
        let bmr = calculateBMR(gender: gender, age: age, weight: weight, height: height)
        
        // Calculate TDEE (Total Daily Energy Expenditure) using activity level
        let tdee = bmr * activityLevel
        
        var caloricIntake: Double
                
        switch selectedWeightGoal {
        case .lose1KgPerWeek:
            caloricIntake = tdee - 7700 / 7 // 7700 calories per kg, 1 kg per week
        case .lose0_5KgPerWeek:
            caloricIntake = tdee - 3850 / 7 // 3850 calories per kg, 0.5 kg per week
        case .maintain:
            caloricIntake = tdee
        case .gain0_5KgPerWeek:
            caloricIntake = tdee + 3850 / 7 // 3850 calories per kg, 0.5 kg per week
        case .gain1KgPerWeek:
            caloricIntake = tdee + 7700 / 7 // 7700 calories per kg, 1 kg per week
        }
        
        return Int(caloricIntake)
    }
    
    private func calculateBMR(gender: Gender, age: Double, weight: Double, height: Double) -> Double {
        switch gender {
        case .male:
            return 88.362 + (13.397 * weight) + (4.799 * height) - (5.677 * age)
        case .female:
            return 447.593 + (9.247 * weight) + (3.098 * height) - (4.330 * age)
        }
    }

    func calculateMacronutrients(caloricIntake: Int) -> (protein: Double, carbs: Double, fat: Double) {
        // Calculate macronutrients based on percentage ranges
        let proteinPercentage = 0.20
        let carbsPercentage = 0.45
        let fatPercentage = 0.35
        
        let protein = proteinPercentage * Double(caloricIntake) / 4.0 // 1 gram of protein = 4 calories
        let carbs = carbsPercentage * Double(caloricIntake) / 4.0 // 1 gram of carbs = 4 calories
        let fat = fatPercentage * Double(caloricIntake) / 9.0 // 1 gram of fat = 9 calories
        
        return (protein, carbs, fat)
    }
}
