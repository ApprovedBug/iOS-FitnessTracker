//
//  DebugMenuViewModel.swift
//
//
//  Created by Jack Moseley on 21/03/2024.
//

import Foundation
import SwiftUI

@Observable
public class DebugMenuViewModel {
    
    var options: [DebugMenuOptionViewModel]
    
    public init(options: [DebugMenuOption]) {
        self.options = options.map({ option in
            DebugMenuOptionViewModel(option: option)
        })
    }
}
