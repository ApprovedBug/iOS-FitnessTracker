//
//  MacrosView.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 06/04/2024.
//

import Foundation
import SwiftUI

struct MacrosView: View {
    
    var viewModel: MacrosViewModel
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 4) {
            Text("\(viewModel.summary) \(viewModel.title)")
            
            ProgressView(value: viewModel.progress)
        }
    }
}
