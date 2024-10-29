//
//  WelcomeView.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 07/12/2023.
//

import Foundation
import FitnessUI
import SwiftUI

struct WelcomeView: View {
    
    @State private var animationStarted = false
    @Bindable var viewModel: WelcomeViewModel
    let appRootManaging: AppRootManaging
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 32) {
                
                Text("We are here to help you keep track of your diet and achieve your goals")
                    .font(.subheadline)
                    .multilineTextAlignment(.leading)
                    .opacity(animationStarted ? 1 : 0)
                    .offset(x: animationStarted ? 0 : 10, y: 0)
                    .animation(Animation.easeInOut(duration: 0.5).delay(0.1), value: animationStarted)
                
                Text("To get started we'd love to know a little bit about you so we can help you as best we can")
                    .font(.subheadline)
                    .multilineTextAlignment(.leading)
                    .opacity(animationStarted ? 1 : 0)
                    .offset(x: animationStarted ? 0 : 10, y: 0)
                    .animation(Animation.easeInOut(duration: 0.5).delay(0.2), value: animationStarted)
                
                Button("Continue") {
                    viewModel.continueTapped()
                }
                .navigationDestination(isPresented: $viewModel.showOnboardingView) {
                    OnboardingView(viewModel: OnboardingViewModel(), appRootManaging: appRootManaging).navigationBarBackButtonHidden(true)
                }
                .buttonStyle(RoundedButtonStyle())
                .opacity(animationStarted ? 1 : 0)
                .animation(Animation.easeInOut(duration: 0.5).delay(1), value: animationStarted)
            }
            .onAppear {
                withAnimation {
                    animationStarted = true
                }
            }
            .navigationTitle("Welcome")
            .padding()
        }
    }
}
