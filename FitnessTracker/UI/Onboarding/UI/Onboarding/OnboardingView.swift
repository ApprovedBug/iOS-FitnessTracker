//
//  OnboardingView.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 20/11/2023.
//

import Foundation
import FitnessUI
import SwiftUI

struct OnboardingView: View {
    
    @Bindable var viewModel: OnboardingViewModel
    
    var body: some View {
        NavigationStack {
            
            VStack {
                List {
                    Section(header: Text("Tell us about yourself")) {
                        
                        Picker("Gender", selection: $viewModel.gender) {
                            ForEach(Gender.allCases, id: \.self) { gender in
                                Text(gender.description)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        
                        TextField("Age", text: $viewModel.age)
                            .keyboardType(.numberPad)
                        TextField("Weight (kg)", text: $viewModel.weight)
                            .keyboardType(.numberPad)
                        TextField("Height (cm)", text: $viewModel.height)
                            .keyboardType(.numberPad)
                        
                        Picker("Activity Level", selection: $viewModel.selectedActivityLevel) {
                            ForEach(ActivityLevel.allCases, id: \.self) { level in
                                Text(level.description).tag(level)
                            }
                        }
                        
                        Picker("Weight Goal", selection: $viewModel.selectedWeightGoal) {
                            ForEach(WeightGoal.allCases, id: \.self) { goal in
                                Text(goal.description).tag(goal)
                            }
                        }
                    }
                }
                .listStyle(PlainListStyle())
                
                Spacer()
                
                Button("Continue") {
                    Task {
                        await viewModel.continueTapped()
                    }
                }
                .navigationDestination(isPresented: $viewModel.showDiaryView) {
                    AppTabView().navigationBarBackButtonHidden()
                }
                .padding()
                .buttonStyle(RoundedButtonStyle())
                .listRowSeparator(.hidden)
                
                Button("Skip") {
                    viewModel.skipTapped()
                }
                .padding()
                .buttonStyle(TertiaryButtonStyle())
                .listRowSeparator(.hidden)
            }
            .navigationTitle("Calorie Calculator")
        }
    }
}

#Preview {
    let viewModel = OnboardingViewModel()
    return OnboardingView(viewModel: viewModel)
}
