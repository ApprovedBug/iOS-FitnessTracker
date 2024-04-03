//
//  DebugMenuViewModel.swift
//
//
//  Created by Jack Moseley on 21/03/2024.
//

import ConfigurationManagement
import DependencyManagement
import Foundation
import SwiftUI

@Observable
public class DebugMenuViewModel {
    
    @ObservationIgnored
    @Inject
    var appConfigurationManager: AppConfigurationManaging
    
    var options: [DebugMenuOptionViewModel]
    
    public init(options: [DebugMenuOption]) {
        self.options = options.map({ option in
            return DebugMenuOptionViewModel(option: option)
        })
    }
}
