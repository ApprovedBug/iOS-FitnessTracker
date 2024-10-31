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
    @Environment(\.presentationMode) var presentationMode
    
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
    
    func contentView(items: [FoodItemViewModel]) -> some View {
        
        ScrollView {
            LazyVStack {
                ForEach(items) { item in
                    FoodItemView(viewModel: item)
                        .onTapGesture {
                            viewModel.addFoodItem(item.foodItem)
                            presentationMode.wrappedValue.dismiss()
                        }
                }
            }
        }
    }
    
    func emptyView() -> some View {
        
        VStack(spacing: 10) {
            Text("No results found")
            
            Button("Tap to add new food item") {
                viewModel.createFoodItemTapped()
            }
        }
        .sheet(isPresented: $viewModel.isCreateFoodItemOpen) {
            AddFoodItemView(viewModel: AddFoodItemViewModel())
        }
    }
}
