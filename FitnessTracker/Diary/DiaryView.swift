//
//  DiaryView.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 22/10/2023.
//

import Foundation
import SwiftUI

struct DiaryView: View {
    
    var body: some View {
        
        ScrollView {
            
            VStack {
                
                SummaryView()
                
                DatePickerView()
                
                MealsView()
                
                WaterView()
            }
        }
    }
}
