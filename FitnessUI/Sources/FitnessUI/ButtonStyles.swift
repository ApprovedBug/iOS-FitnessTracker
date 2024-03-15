//
//  ButtonStyles.swift
//
//
//  Created by Jack Moseley on 15/03/2024.
//

import Foundation
import SwiftUI


// Custom Button Style
public struct RoundedButtonStyle: ButtonStyle {
    
    public init() {}
    
    public func makeBody(configuration: Configuration) -> some View {
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
public struct TertiaryButtonStyle: ButtonStyle {
    public init() {}
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding() // Add padding
            .foregroundColor(.blue)
    }
}
