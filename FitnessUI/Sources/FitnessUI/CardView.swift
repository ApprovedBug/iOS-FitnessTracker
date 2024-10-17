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
                .shadow(
                    color: Color(UIColor.label).opacity(0.1),
                    radius: 3,
                    x: 0, y: 0
                )
            
            viewBuilder()
                .padding()
        }
        .padding([.leading, .trailing, .bottom])
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
