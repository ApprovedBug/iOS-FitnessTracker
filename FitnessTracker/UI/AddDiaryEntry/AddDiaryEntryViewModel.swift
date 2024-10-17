//
//  AddDiaryEntryViewModel.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 02/08/2024.
//

import Foundation

@Observable
class AddDiaryEntryViewModel {
    
    var isCreateFoodItemOpen: Bool = false
    
    func createFoodItemTapped() {
        isCreateFoodItemOpen = true
    }
}
