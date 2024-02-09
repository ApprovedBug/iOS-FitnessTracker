//
//  OnboardingView.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 20/11/2023.
//

import Foundation
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
                    viewModel.continueTapped()
                }
                .navigationDestination(isPresented: $viewModel.showDiaryView) {
                    AppTabView()
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
            .navigationBarTitle("Calorie Calculator")
        }
    }
}

// Custom Button Style
struct RoundedButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            Color.blue
                .frame(height: 40)
            
            configuration.label
                .padding([.top, .bottom], 8) // Add padding
                .foregroundColor(.white) // Text color
        }
        .cornerRadius(10)
    }
}

// Custom Button Style
struct TertiaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding() // Add padding
            .foregroundColor(.blue)
    }
}

#Preview {
    let viewModel = OnboardingViewModel()
    return OnboardingView(viewModel: viewModel)
}
