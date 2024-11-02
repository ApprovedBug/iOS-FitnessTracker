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
    
    struct EventHandler {
        let removeEntryTapped: (DiaryEntry) -> Void
    }
    
    private let diaryEntry: DiaryEntry
    private let eventHandler: EventHandler
    
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
