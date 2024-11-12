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
                ProgressView()
                    .onAppear {
                        Task {
                            await viewModel.loadInitialState()
                        }
                    }
            case .searchResults(let items, let meals):
                FoodItemList(
                    recentItems: items,
                    meals: meals,
                    addFoodItemTapped: viewModel.addFoodItemTapped,
                    createFoodItemTapped: viewModel.createFoodItemTapped,
                    scanItemTapped: viewModel.scanItemTapped,
                    cancelSearch: viewModel.clearSearch
                )
                .searchable(text: $viewModel.searchTerm)
                .onSubmit(of: .search) {
                    Task {
                        await viewModel.search()
                    }
                }
                .onChange(of: viewModel.searchTerm) { oldValue, newValue in
                    viewModel.filter()
                }
            case .empty:
                EmptyResultsView(
                    createFoodItemTapped: viewModel.createFoodItemTapped,
                    cancelSearch: viewModel.clearSearch
                )
                .searchable(text: $viewModel.searchTerm)
                .onSubmit(of: .search) {
                    Task {
                        await viewModel.search()
                    }
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
        .alert("Error",
               isPresented: $viewModel.isShowingError,
               presenting: viewModel.errorMessage,
               actions: { details in
            Button("Create new item") {
                viewModel.createFoodItemTapped()
            }
            Button("Retry") {
                Task {
                    await viewModel.scanItemTapped()
                }
            }
            Button("Cancel") {
                
            }
        }, message: { details in
            Text(details)
        })
        .fullScreenCover(item: $viewModel.barcodeScannerView, content: { barcodeScanner in
            barcodeScanner
                .ignoresSafeArea(.all)
                .onAppear {
                    Task {
                        await viewModel.scannerPresented()
                    }
                }
        })
        .toast(isPresented: $viewModel.showToast, message: "Food item added!")
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
        let createFoodItemTapped: () -> Void
        let scanItemTapped: @MainActor () async -> Void
        let cancelSearch: @MainActor () async -> Void
        
        var body: some View {
            SlidingTabView(isScrollable: false) {
                
                SlidingTabItem("All") {
                    
                    VStack(spacing: 12) {
                        HStack(spacing: 12) {
                            Button("Create new food item") {
                                createFoodItemTapped()
                            }
                            .buttonStyle(RoundedButtonStyle())
                            
                            Button("Scan item") {
                                Task {
                                    await scanItemTapped()
                                }
                            }
                            .buttonStyle(RoundedButtonStyle())
                        }
                        .padding(.horizontal)
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
                    Task {
                        await cancelSearch()
                    }
                }
            }
        }
    }
    
    struct EmptyResultsView: View {
        @Environment(\.isSearching) var isSearching
        
        let createFoodItemTapped: () -> Void
        let cancelSearch: @MainActor () async -> Void
        
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
                    Task {
                        await cancelSearch()
                    }
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
