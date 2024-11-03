//
//  MealEntryViewModel.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 31/10/2024.
//

import FitnessPersistence
import Foundation

@Observable
class MealEntryViewModel: Identifiable {
    
    struct EventHandler {
        let removeEntryTapped: (DiaryEntry) -> Void
    }
    
    private let diaryEntry: DiaryEntry
    private let eventHandler: EventHandler
    
    var isExpanded: Bool = false
    
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
        String(format: "%.1f", diaryEntry.totalProteins)
    }
    
    var fat: String {
        String(format: "%.1f", diaryEntry.totalFats)
    }
    
    init(diaryEntry: DiaryEntry, eventHandler: EventHandler) {
        self.diaryEntry = diaryEntry
        self.eventHandler = eventHandler
    }
    
    func toggleExpanded() {
        isExpanded.toggle()
    }
    
    func editDiaryEntryTapped() {
        // TODO: Implement editing entries
    }
    
    func removeDiaryEntryTapped() {
        eventHandler.removeEntryTapped(diaryEntry)
    }
}
