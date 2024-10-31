//
//  MealsView.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 22/10/2023.
//

import Foundation
import SwiftUI

struct MealListView: View {
    
    var viewModel: MealListViewModel
    
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
    
    let items: [MealListItemViewModel]
    
    var body: some View {
     
        ForEach(items) { item in
            
            MealListItemView(viewModel: item)
        }
    }
}
