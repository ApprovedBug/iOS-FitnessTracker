//
//  MealDetailsItemView.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 16/11/2024.
//

import Foundation
import SwiftUI

struct MealDetailsItemView: View {
    
    let viewModel: MealDetailsItemViewModel
    
    var body: some View {
        Text(viewModel.name)
    }
}
