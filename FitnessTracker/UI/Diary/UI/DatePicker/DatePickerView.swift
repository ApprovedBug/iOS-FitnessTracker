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
        
        CardView {
            HStack {
                
                Button(action: { viewModel.previousDay() }) {
                    Image(systemName: "chevron.left")
                }
                
                Spacer()
                
                Text(viewModel.title)
                
                Spacer()
                
                Button(action: { viewModel.nextDay() }) {
                    Image(systemName: "chevron.right")
                }
            }
        }
    }
}
