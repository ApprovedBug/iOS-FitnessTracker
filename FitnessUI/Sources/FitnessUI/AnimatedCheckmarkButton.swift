//
//  AnimatedCheckmarkButton.swift
//  FitnessUI
//
//  Created by Jack Moseley on 13/11/2024.
//

import Foundation
import SwiftUI

public struct AnimatedCheckmarkButton: View {
    var action: () async -> Void
    
    public init(action: @escaping () async -> Void) {
        self.action = action
    }

    @State private var isTapped = false
    @State private var isCheckmarkVisible = false

    public var body: some View {
        Button {
            isTapped = true
            
            // Pulse animation and change to checkmark
            withAnimation(.easeInOut(duration: 0.2)) {
                isCheckmarkVisible = true
            }
            
            // Delay to show the checkmark before reverting back to plus
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isCheckmarkVisible = false
                    isTapped = false
                }
            }

            // Perform the action
            Task {
                await action()
            }
        } label: {
            Image(systemName: isCheckmarkVisible ? "checkmark.circle" : "plus.circle")
                .font(.headline)
                .foregroundColor(isCheckmarkVisible ? .green : .blue)
                .scaleEffect(isTapped ? 1.2 : 1.0)
                .animation(.easeInOut(duration: 0.2).repeatCount(1, autoreverses: true), value: isTapped)
        }
    }
}
