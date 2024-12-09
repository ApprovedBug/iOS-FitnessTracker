//
//  DatePickerView.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 22/10/2023.
//

import FitnessUI
import Foundation
import SwiftUI

struct DatePickerView: View {
    
    @Bindable var viewModel: DatePickerViewModel
    
    var body: some View {
        
        VStack {
            
            HStack {
                Button(action: { viewModel.previousDay() }) {
                    Image(systemName: "chevron.left")
                        .padding()
                }
                .frame(height: 40)
                
                Spacer()
                
                Text(viewModel.title)
                    .padding(.vertical)
                
                Spacer()
                
                Button(action: { viewModel.nextDay() }) {
                    Image(systemName: "chevron.right")
                        .padding()
                }
                .frame(height: 40)
            }
        }
        .background(Color.primary.opacity(0.1))
    }
}
