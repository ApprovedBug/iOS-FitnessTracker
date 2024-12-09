//
//  TabView.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 21/11/2023.
//

import Foundation
import SwiftUI

struct AppTabView: View {
    
    let viewModel: AppTabViewModel
    
    var body: some View {
        
        TabView {
            ForEach(viewModel.tabs) { tab in
                Tab(tab.title, systemImage: tab.image) {
                    switch tab.tabType {
                        case .diary:
                            NavigationStack {
                                DiaryView(viewModel: viewModel.diaryViewModel)
                            }
                        case .weight:
                            NavigationStack {
                                WeightView(viewModel: viewModel.weightViewModel)
                                    .navigationTitle("Weight")
                            }
                        case .account:
                            AccountView()
                    }
                }
            }
        }
    }
}
