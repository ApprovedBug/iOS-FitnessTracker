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
            switch viewModel.state {
            case .idle:
                EmptyView()
            case .loading:
                ProgressView()
            case .searchResults(let items, let meals):
                foodItemList(recentItems: items, meals: meals)
            case .empty:
                emptyResultsView()
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
    
    func foodItemList(
        recentItems: [FoodItemViewModel],
        meals: [FoodItemViewModel]
    ) -> some View {
        
        SlidingTabView(isScrollable: false) {
            
            SlidingTabItem("All") {
                ScrollView {
                    LazyVStack {
                        ForEach(recentItems) { item in
                            FoodItemView(viewModel: item)
                                .onTapGesture {
                                    viewModel.addFoodItemTapped(item.foodItem)
                                }
                        }
                    }
                    .padding([.leading, .trailing])
                }
            }
            
            SlidingTabItem("Meals") {
                ScrollView {
                    LazyVStack {
                        ForEach(meals) { meal in
                            FoodItemView(viewModel: meal)
                        }
                    }
                    .padding([.leading, .trailing])
                }
            }
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
