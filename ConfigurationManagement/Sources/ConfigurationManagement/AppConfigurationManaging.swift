//
//  AppConfigurationManaging.swift
//
//
//  Created by Jack Moseley on 26/03/2024.
//

import DependencyManagement
import Foundation

public protocol UserDefaultsProtocol: Sendable {
    func bool(forKey defaultName: String) -> Bool
    func set(_ value: Bool, forKey defaultName: String)
}

extension UserDefaults: UserDefaultsProtocol {}

public protocol AppConfigurationKey {
    
    var name: String { get }
}

public protocol AppConfigurationManaging: Sendable {
    
    func getValue(for key: AppConfigurationKey) -> Bool
    func setValue(value: Bool, key: AppConfigurationKey)
}

public final class AppConfigurationManager: AppConfigurationManaging {
    
    @Inject
    private var userDefaults: UserDefaultsProtocol

    public init() { }

    public func getValue(for key: AppConfigurationKey) -> Bool {
        userDefaults.bool(forKey: key.name)
    }
    
    public func setValue(value: Bool, key: AppConfigurationKey) {
        userDefaults.set(value, forKey: key.name)
    }
}
