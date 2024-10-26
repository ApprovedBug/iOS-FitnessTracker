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
    
    var viewModel: DiaryViewModel
    
    var body: some View {
            
        switch viewModel.state {
        case .idle, .loading:
            ProgressView().onAppear(perform: {
                viewModel.loadData()
            })
        case .error:
            Text("There was an error loading your diary")
        case .ready(let entries):
            ContentView(entries: entries)
        }
    }
}

private struct ContentView: View {
    
    let entries: [DiaryEntry]
    
    var body: some View {
        ScrollView {
            
            VStack {
                
                SummaryView(viewModel: SummaryViewModel(entries: entries))
                
//                DatePickerView()
//                
                MealsView(viewModel: MealsViewModel(entries: entries))
//
//                WaterView()
            }
        }
    }
}


//#Preview {
//    
//    DiaryView(viewModel: DiaryViewModel(diaryFetching: MockDiaryRepository()))
//}
