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
            FoodItemList(
                items: viewModel.itemListViewModel,
                meals: viewModel.mealItemViewModels,
                addFoodItemTapped: viewModel.addFoodItemTapped,
                createFoodItemTapped: viewModel.createFoodItemTapped,
                scanItemTapped: viewModel.scanItemTapped,
                cancelSearch: viewModel.clearSearch
            )
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .searchable(text: $viewModel.searchTerm)
            .onSubmit(of: .search) {
                Task {
                    await viewModel.search()
                }
            }
            .onChange(of: viewModel.searchTerm) { oldValue, newValue in
                viewModel.filter()
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
    
    struct FoodItemList: View {
        @Environment(\.isSearching) var isSearching
        
        let items: AddDiaryEntryViewModel.ItemListViewModel
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
                        if items.isLoading {
                            Spacer()
                            ProgressView()
                            Spacer()
                        } else {
                            ScrollView {
                                LazyVStack {
                                    ForEach(items.foodItemViewModels) { item in
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
