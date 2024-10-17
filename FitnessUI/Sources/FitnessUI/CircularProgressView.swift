//
//  CircularProgressView.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 06/11/2023.
//

import Foundation
import SwiftUI

public struct CircularProgressView: View {
    let progress: Double
    
    public init(progress: Double) {
        self.progress = progress
    }
    
    public var body: some View {
        ZStack {
            Circle()
                .stroke(
                    Color.blue.opacity(0.5),
                    lineWidth: 10
                )
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    Color.blue,
                    style: StrokeStyle(lineWidth: 10, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
        }
    }
}
