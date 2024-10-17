//
//  MacrosViewModel.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 06/04/2024.
//

import Foundation

@Observable
class MacrosViewModel: Identifiable {
    
    let summary: String
    let progress: Double
    let title: String
    
    init(consumed: Double, target: Double, title: String) {
        
        self.summary = String(format: "%.0f/%.0f", consumed, target)
        self.progress = consumed/target
        self.title = title
    }
}
