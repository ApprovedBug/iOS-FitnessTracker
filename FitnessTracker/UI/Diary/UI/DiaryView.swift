//
//  DiaryView.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 22/10/2023.
//

import FitnessPersistence
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
        
        ScrollView {
            VStack {
                SummaryView(viewModel: viewModel.summaryViewModel)
                
                DatePickerView(viewModel: viewModel.dateViewModel)

                MealListView(viewModel: viewModel.mealListViewModel)
                
    //                WaterView()
            }
        }
    }
}


//#Preview {
//    
//    DiaryView(viewModel: DiaryViewModel(diaryFetching: MockDiaryRepository()))
//}
