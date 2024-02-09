//
//  MealsView.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 22/10/2023.
//

import Foundation
import SwiftUI

struct MealsView: View {
    
    var viewModel: MealsViewModel
    
    var body: some View {
        
        switch viewModel.state {
            case .idle:
                EmptyView()
            case .ready(let items):
                ContentView(items: items)
        }
    }
}

private struct ContentView: View {
    
    let items: [MealItemViewModel]
    
    var body: some View {
     
        ForEach(items) { item in
            
            MealItemView(viewModel: item)
        }
    }
}
