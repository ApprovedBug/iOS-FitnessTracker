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
                FoodItemList(
                    recentItems: items,
                    meals: meals,
                    addFoodItemTapped: viewModel.addFoodItemTapped,
                    cancelSearch: viewModel.clearSearch
                )
                .searchable(text: $viewModel.searchText)
                .onSubmit(of: .search) {
                    viewModel.search()
                }
            case .empty:
                EmptyResultsView(
                    createFoodItemTapped: viewModel.createFoodItemTapped,
                    cancelSearch: viewModel.clearSearch
                )
                .searchable(text: $viewModel.searchText)
                .onSubmit(of: .search) {
                    viewModel.search()
                }
            }
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
    
    struct FoodItemList: View {
        @Environment(\.isSearching) var isSearching
        
        let recentItems: [FoodItemViewModel]
        let meals: [MealItemViewModel]
        let addFoodItemTapped: (FoodItem) -> Void
        let cancelSearch: () -> Void
        
        var body: some View {
            SlidingTabView(isScrollable: false) {
                
                SlidingTabItem("All") {
                    ScrollView {
                        LazyVStack {
                            ForEach(recentItems) { item in
                                FoodItemView(viewModel: item)
                                    .onTapGesture {
                                        addFoodItemTapped(item.foodItem)
                                    }
                            }
                        }
                        .padding([.leading, .trailing])
                    }
                }
                
                SlidingTabItem("Meals") {
                    ScrollView {
                        LazyVStack {
                            ForEach(meals) { viewModel in
                                MealItemView(viewModel: viewModel)
                            }
                        }
                        .padding([.leading, .trailing])
                    }
                }
            }
            .onChange(of: isSearching) { oldValue, newValue in
                if !newValue {
                    cancelSearch()
                }
            }
        }
    }
    
    struct EmptyResultsView: View {
        @Environment(\.isSearching) var isSearching
        
        let createFoodItemTapped: () -> Void
        let cancelSearch: () -> Void
        
        var body: some View {
            VStack(alignment: .center, spacing: 10) {
                Spacer()
                
                Text("No results found")
                
                Button("Tap to create a new food item") {
                    createFoodItemTapped()
                }
                .buttonStyle(TertiaryButtonStyle())
                
                Spacer()
            }
            .onChange(of: isSearching) { oldValue, newValue in
                if !newValue {
                    cancelSearch()
                }
            }
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
