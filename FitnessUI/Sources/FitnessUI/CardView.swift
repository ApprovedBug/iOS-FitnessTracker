//
//  CardView.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 17/11/2023.
//

import Foundation
import SwiftUI

public struct CardView<Content: View>: View {

    let viewBuilder: () -> Content
    
    public init(viewBuilder: @escaping () -> Content) {
        self.viewBuilder = viewBuilder
    }
    
    public var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color("CardBackground", bundle: .module))
            
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .strokeBorder(Color("CardBorder", bundle: .module), lineWidth: 1)
            
            viewBuilder()
                .padding()
        }
    }
}
