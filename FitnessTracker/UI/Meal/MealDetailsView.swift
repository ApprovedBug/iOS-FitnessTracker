//
//  MealDetailsView.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 16/11/2024.
//

import Foundation
import SwiftUI

struct MealDetailsView: View {
    
    @Bindable var viewModel: MealDetailsViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        NavigationView {
            VStack(alignment: .leading) {
                
                Text(viewModel.title)
                    .font(.title)
                    .padding()
                
                List {
                    ForEach(viewModel.foodItems) { item in
                            
                        MealDetailsItemView(viewModel: item)
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    print("Delete tapped")
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                    }
                }
                .listStyle(.plain)
            }
            .navigationBarItems(trailing: Button("Done") {
                Task {
                    presentationMode.wrappedValue.dismiss()
                }
            })
        }
    }
}
