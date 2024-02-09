//
//  CardView.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 17/11/2023.
//

import Foundation
import SwiftUI

struct CardView<Content: View>: View {

    let viewBuilder: () -> Content
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color(red: 250 / 255, green: 250 / 255, blue: 250 / 255))
                .shadow(
                    color: Color(UIColor.lightGray).opacity(0.5),
                    radius: CGFloat(3),
                    x: CGFloat(0), y: CGFloat(0))
            
            viewBuilder()
                .padding()
        }
        .padding([.leading, .trailing, .bottom])
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
