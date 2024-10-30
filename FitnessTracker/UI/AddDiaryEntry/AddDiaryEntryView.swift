//
//  AddDiaryEntryView.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 02/08/2024.
//

import FitnessPersistence
import Foundation
import SwiftUI

struct AddDiaryEntryView: View {
    
    @Bindable var viewModel: AddDiaryEntryViewModel
    
    var body: some View {
        
        NavigationStack {
            
            switch viewModel.state {
                case .idle:
                    Text("Search for your item")
                case .loading:
                    ProgressView()
                case .success(let items):
                    contentView(items: items)
                case .empty:
                    emptyView()
            }
        }
        .searchable(text: $viewModel.searchText)
        .onSubmit(of: .search) {
            viewModel.search()
        }
    }
    
    func contentView(items: [FoodItem]) -> some View {
        
        ForEach(items) { item in
            Text("\(item.name)")
        }
    }
    
    func emptyView() -> some View {
        
        VStack {
            Text("No results found")
            
            Button("Tap to add new food item") {
                viewModel.createFoodItemTapped()
            }
        }
    }
}
