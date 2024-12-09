//
//  DiaryView.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 22/10/2023.
//

import FitnessPersistence
import FitnessUI
import Foundation
import SwiftUI

struct DiaryView: View {
    
    @Bindable var viewModel: DiaryViewModel
    
    var body: some View {
            
        switch viewModel.state {
        case .idle, .loading:
            ProgressView().onAppear(perform: {
                viewModel.loadData()
            })
        case .error:
            Text("There was an error loading your diary")
        case .ready:
            contentView()
        }
    }
    
    private func contentView() -> some View {
        
        VStack(spacing: 0) {
            
            DatePickerView(viewModel: viewModel.dateViewModel)
            
            List {
                if let summaryViewModel = viewModel.summaryViewModel {
                    SummaryView(viewModel: summaryViewModel)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets())
                        .padding()
                        .padding([.top], 24)
                }
                
                if let mealListViewModel = viewModel.mealListViewModel {
                    MealListView(viewModel: mealListViewModel)
                }
            }
            .listStyle(PlainListStyle())
        }
        .sheet(isPresented: $viewModel.isAddDiaryEntryOpen) {
            if let addDiaryEntryViewModel = viewModel.addDiaryEntryViewModel {
                AddDiaryEntryView(viewModel: addDiaryEntryViewModel)
            }
        }
        .sheet(isPresented: $viewModel.isShowingSaveMealAlert) {
            VStack(alignment: .leading, spacing: 16) {
                Text("Save meal")
                    .font(.title)
                Text("Saving meals makes it easier to add commonly tracked foods to your diary.")
                TextField("Enter Meal Name i.e. Scrambled eggs on toast", text: $viewModel.mealName)
                    .textFieldStyle(.roundedBorder)
                    .font(.body)
                    .multilineTextAlignment(.leading)
                Spacer()
                Button("Save Meal") {
                    viewModel.saveMealTapped()
                }
                .buttonStyle(RoundedButtonStyle())
                .disabled(!viewModel.mealNameValid)
                
            }
            .padding()
            .presentationDetents([.small])
        }
        .sheet(isPresented: $viewModel.isShowingEditItem, content: {
            if let addFoodItemViewModel = viewModel.addFoodItemViewModel {
                AddFoodItemView(viewModel: addFoodItemViewModel)
                    .presentationDetents([.small])
            }
        })
    }
}


#Preview {
    
    DiaryView(viewModel: DiaryViewModel())
}
