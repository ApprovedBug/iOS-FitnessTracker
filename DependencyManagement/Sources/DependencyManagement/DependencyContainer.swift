//
//  DependencyContainer.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 20/11/2023.
//

import Foundation

public class DependencyContainer {
    static let shared = DependencyContainer()

    init() {}

    private var registrations: [String: Any] = [:]

    public static func register<T>(_ type: T.Type, factory: @escaping () -> T) {
        let key = String(describing: T.self)
        shared.registrations[key] = factory
    }
    
    public static func resolve<T>(_ type: T.Type) -> T? {
        shared.resolve(T.self)
    }

    func resolve<T>(_ type: T.Type) -> T? {
        let key = String(describing: T.self)
        if let factory = registrations[key] as? () -> T {
            return factory()
        }
        return nil
    }
}

@propertyWrapper
public struct Inject<T> {
    private var container: DependencyContainer = DependencyContainer.shared
    private let value: T

    public var wrappedValue: T {
        return value
    }

    public init() {
        guard let resolvedValue = container.resolve(T.self) else {
            fatalError("Dependency not registered: \(T.self)")
        }
        value = resolvedValue
    }
}
