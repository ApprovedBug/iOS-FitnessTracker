//
//  WelcomeViewModel.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 07/12/2023.
//

import Foundation

@Observable
class WelcomeViewModel {
    
    var showOnboardingView = false
    
    func continueTapped() {
        showOnboardingView = true
    }
}
