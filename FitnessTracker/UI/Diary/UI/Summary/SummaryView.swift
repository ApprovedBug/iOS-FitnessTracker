//
//  SummaryView.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 22/10/2023.
//

import FitnessUI
import Foundation
import SwiftUI

struct SummaryView: View {
    
    var viewModel: SummaryViewModel
    
    var body: some View {
        
        switch viewModel.state {
            case .ready(let data):
                ContentView(data: data)
            default:
                EmptyView()
        }
    }
}

private struct ContentView: View {
    
    let data: SummaryViewModel.Data
    
    var body: some View {
        VStack {
            
            HStack {
                
                VStack(alignment: .leading) {
                    KcalSummaryItemView(
                        title: "Consumed",
                        icon: Image(systemName: "apple.logo"),
                        value: data.kcalConsumed
                    )
                    Spacer()
                    KcalSummaryItemView(
                        title: "Burned",
                        icon: Image(systemName: "flame.fill"),
                        value: data.kcalBurned
                    )
                }
                
                Spacer()
                
                KcalRemainingView(progress: data.kcalProgress, kcalRemaining: data.kcalRemaining)
            }
            .padding([.bottom], 32)
            
            HStack {
                MacrosView(viewModel: data.carbsViewModel)
                MacrosView(viewModel: data.proteinViewModel)
                MacrosView(viewModel: data.fatsViewModel)
            }
        }
    }
}

private struct KcalSummaryItemView: View {
    
    let title: String
    let icon: Image
    let value: String
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            Text(title)
            
            HStack {
                icon
                
                Text("\(value)Kcal")
            }
        }
    }
}

private struct KcalRemainingView: View {
    
    let progress: Double
    let kcalRemaining: String
    
    var body: some View {
        ZStack {
            CircularProgressView(progress: progress)
                        .frame(width: 150, height: 150)
            
            VStack {
                Text(kcalRemaining)
                Text("Remaining")
            }
        }
    }
}
