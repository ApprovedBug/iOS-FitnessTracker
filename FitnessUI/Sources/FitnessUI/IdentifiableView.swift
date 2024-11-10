//
//  IdentifiableView.swift
//  FitnessUI
//
//  Created by Jack Moseley on 10/11/2024.
//

import Foundation
import SwiftUI

public struct IdentifiableView: View, Identifiable {
    public let id = UUID()
    let content: AnyView
    
    public init<V: View>(view: V) {
        self.content = AnyView(view)
    }
    
    public var body: some View {
        content
    }
}
