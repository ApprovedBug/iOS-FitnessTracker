//
//  AddDiaryEntryView.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 02/08/2024.
//

import FitnessPersistence
import FitnessUI
import Foundation
import SwiftUI

struct AddDiaryEntryView: View {
    
    @Bindable var viewModel: AddDiaryEntryViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        NavigationStack {
            
            VStack {
                Button("Add new food item") {
                    viewModel.createFoodItemTapped()
                }
                .padding()
                .buttonStyle(RoundedButtonStyle())
                
                switch viewModel.state {
                    case .idle:
                        EmptyView()
                    case .recentItems(let items):
                        VStack(alignment: .leading) {
                            Text("Recent Items")
                                .padding([.leading, .trailing, .bottom])
                                .font(.title)
                            
                            foodItemList(items: items)
                        }
                    case .noRecentItems:
                        Text("Your recent items will appear here.")
                    case .loading:
                        ProgressView()
                    case .success(let items):
                        VStack(alignment: .leading) {
                            Text("Results")
                                .padding([.leading, .trailing, .bottom])
                                .font(.title)
                            
                            foodItemList(items: items)
                        }
                    case .empty:
                        emptyView()
                }
            }
        }
        .searchable(text: $viewModel.searchText)
        .onSubmit(of: .search) {
            viewModel.search()
        }
        .sheet(isPresented: $viewModel.isCreateFoodItemOpen) {
            AddFoodItemView(viewModel: AddFoodItemViewModel())
        }
    }
    
    func foodItemList(items: [FoodItemViewModel]) -> some View {
        
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
        
        VStack(alignment: .center, spacing: 10) {
            Spacer()
            
            Text("No results found")
            
            Button("Tap to add new food item") {
                viewModel.createFoodItemTapped()
            }
            .buttonStyle(TertiaryButtonStyle())
            
            Spacer()
        }
    }
}
