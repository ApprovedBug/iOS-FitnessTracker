//
//  MealEntryViewModel.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 31/10/2024.
//

import FitnessPersistence
import Foundation

@Observable
class MealEntryViewModel {
    
    private let diaryEntry: DiaryEntry
    
    var isExpanded: Bool = false
    
    var name: String {
        diaryEntry.foodItem.name
    }
    
    var quantity: String {
        String(diaryEntry.foodItem.quantity)
    }
    
    var measurement: String {
        diaryEntry.foodItem.measurementUnit.rawValue
    }
    
    var kcal: String {
        String(diaryEntry.foodItem.kcal)
    }
    
    var carbs: String {
        String(diaryEntry.foodItem.carbs)
    }
    
    var protein: String {
        String(diaryEntry.foodItem.protein)
    }
    
    var fat: String {
        String(diaryEntry.foodItem.fats)
    }
    
    init(diaryEntry: DiaryEntry) {
        self.diaryEntry = diaryEntry
    }
    
    func toggleExpanded() {
        isExpanded.toggle()
    }
}
