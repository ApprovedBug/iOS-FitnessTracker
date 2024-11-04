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
                
                headerView()
                
                switch viewModel.state {
                    case .idle:
                        EmptyView()
                    case .recentItems(let items):
                        foodItemList(title: "Recent items", items: items)
                            .padding([.leading, .trailing])
                    case .noRecentItems:
                        emptyRecentItemsView()
                    case .loading:
                        ProgressView()
                    case .searchResults(let items):
                        foodItemList(title: "Results", items: items)
                            .padding([.leading, .trailing])
                    case .empty:
                        emptyResultsView()
                }
            }
        }
        .searchable(text: $viewModel.searchText)
        .onSubmit(of: .search) {
            viewModel.search()
        }
        .sheet(isPresented: $viewModel.isShowingCreateNewFoodItem, content: {
            if let addFoodItemViewModel = viewModel.addFoodItemViewModel {
                AddFoodItemView(viewModel: addFoodItemViewModel)
                    .presentationDetents([.large])
            }
        })
        .sheet(isPresented: $viewModel.isShowingAddExistingItem, content: {
            if let addFoodItemViewModel = viewModel.addFoodItemViewModel {
                AddFoodItemView(viewModel: addFoodItemViewModel)
                    .presentationDetents([.small])
            }
        })
        .onChange(of: viewModel.shouldDismiss, {
            presentationMode.wrappedValue.dismiss()
        })
    }
    
    func headerView() -> some View {
        Button("Create new food item") {
            viewModel.createFoodItemTapped()
        }
        .padding()
        .buttonStyle(RoundedButtonStyle())
    }
    
    func foodItemList(title: String, items: [FoodItemViewModel]) -> some View {
        
        VStack(alignment: .leading) {
            Text(title)
                .padding([.bottom])
                .font(.title)
            
            ScrollView {
                LazyVStack {
                    ForEach(items) { item in
                        FoodItemView(viewModel: item)
                            .onTapGesture {
                                viewModel.addFoodItemTapped(item.foodItem)
                            }
                    }
                }
            }
        }
    }
    
    func emptyRecentItemsView() -> some View {
        
        VStack(alignment: .center, spacing: 10) {
            Spacer()
            
            Text("Your recent items will appear here.")
            
            Spacer()
        }
    }
    
    func emptyResultsView() -> some View {
        
        VStack(alignment: .center, spacing: 10) {
            Spacer()
            
            Text("No results found")
            
            Button("Tap to create a new food item") {
                viewModel.createFoodItemTapped()
            }
            .buttonStyle(TertiaryButtonStyle())
            
            Spacer()
        }
    }
}

extension PresentationDetent {
    static let small = Self.fraction(0.35)
}

#Preview {
    
    let viewModel = AddDiaryEntryViewModel(
        date: Date.now,
        mealType: .breakfast
    )
    
    AddDiaryEntryView(viewModel: viewModel)
}
