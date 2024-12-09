//
//  MealsView.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 22/10/2023.
//

import FitnessPersistence
import Foundation
import SwiftUI

struct MealListView: View {
    
    @Bindable var viewModel: MealListViewModel
    
    var body: some View {
        contentView(items: viewModel.currentMeals)
    }
    
    @ViewBuilder
    func contentView(items: [MealListViewModel.ItemViewModel]) -> some View {
        ForEach(items) { item in
            Section {
                ForEach(Array(item.entryViewModels.enumerated()), id: \.offset) { index, entry in
                    VStack(spacing: 0) {
                        MealEntryView(viewModel: entry)
                            .swipeActions {
                                Button(role: .destructive) {
                                    viewModel.deleteEntryTapped(entry: entry)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                                
                                Button {
                                    viewModel.editEntryTapped(entry: entry)
                                } label: {
                                    Label("Edit", systemImage: "pencil")
                                }
                            }
                            .background(Color.primary.opacity(0.1))
                        
                        if index < item.entryViewModels.count - 1 {
                            Divider()
                        }
                    }
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets())
                }
            } header: {
                MealEntryHeaderView(viewModel: item.headerViewModel)
                    .listRowInsets(EdgeInsets())
                    .background(Color.primary.opacity(0.2))
            } footer: {
                sectionFooter(mealType: item.mealType)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets())
                    .background(Color.blue)
            }
        }
    }
    
    @ViewBuilder
    func sectionFooter(mealType: MealType) -> some View {
        Button("Add entry") {
            Task {
                viewModel.addEntryTapped(mealType: mealType)
            }
        }
        .foregroundColor(.white)
        .frame(maxWidth: .infinity)
        .padding([.vertical], 14)
    }
}
