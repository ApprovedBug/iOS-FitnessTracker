//
//  MealEntryViewModel.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 31/10/2024.
//

import FitnessPersistence
import Foundation

@Observable
@MainActor
class MealEntryViewModel: Identifiable {
    
    let diaryEntry: DiaryEntry
    
    var isExpanded: Bool = false
    var isShowingEditItem: Bool = false
    
    var name: String {
        diaryEntry.foodItem.name
    }
    
    var servingSize: String {
        String(Int(Double(diaryEntry.foodItem.servingSize) * diaryEntry.servings))
    }
    
    var measurement: String {
        diaryEntry.foodItem.measurementUnit.rawValue
    }
    
    var kcal: String {
        String(diaryEntry.totalCalories)
    }
    
    var carbs: String {
        String(format: "%.1f", diaryEntry.totalCarbs)
    }
    
    var protein: String {
        String(format: "%.1f", diaryEntry.totalProtein)
    }
    
    var fat: String {
        String(format: "%.1f", diaryEntry.totalFat)
    }
    
    init(diaryEntry: DiaryEntry) {
        self.diaryEntry = diaryEntry
    }
    
    func toggleExpanded() {
        isExpanded.toggle()
    }
}
