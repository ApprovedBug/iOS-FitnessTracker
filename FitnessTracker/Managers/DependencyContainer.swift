//
//  DependencyContainer.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 20/11/2023.
//

import Foundation

protocol Injectable {
    associatedtype T
    static func create() -> T
}

class DependencyContainer {
    static let shared = DependencyContainer()

    init() {}

    func registerDependencies() {
        // Register your dependencies here
        register(ContextProviding.self) {
            PersistanceManager()
        }
        
        register(UserDefaultsProtocol.self) {
            UserDefaults.standard
        }
        
        register(DiaryFetching.self) {
            MockDiaryRepository()
        }
        
        register(AppConfigurationManaging.self) {
            AppConfigurationManager()
        }
    }

    private var registrations: [String: Any] = [:]

    func register<T>(_ type: T.Type, factory: @escaping () -> T) {
        let key = String(describing: T.self)
        registrations[key] = factory
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
struct Inject<T> {
    private var container: DependencyContainer = DependencyContainer.shared
    private let value: T

    var wrappedValue: T {
        return value
    }

    init() {
        guard let resolvedValue = container.resolve(T.self) else {
            fatalError("Dependency not registered: \(T.self)")
        }
        value = resolvedValue
    }
}
