//
//  DebugMenuView.swift
//
//
//  Created by Jack Moseley on 21/03/2024.
//

import Foundation
import SwiftUI

public struct DebugMenuView: View {
    
    @Bindable var viewModel: DebugMenuViewModel
    
    public init(viewModel: DebugMenuViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        
        List {
            
            Text("Debug tools")
                .font(.largeTitle)
            
            ForEach(0..<viewModel.options.count, id: \.self) { index in
                Toggle(viewModel.options[index].title, isOn: $viewModel.options[index].isOn)
            }
        }
        .listStyle(.plain)
    }
}

@Observable
public class DebugMenuOptionViewModel: Identifiable {
    
    @ObservationIgnored
    private let option: DebugMenuOption
    
    var title: String
    var isOn: Bool = false
    
    init(option: DebugMenuOption) {
        self.option = option
        self.title = option.title
    }
}

public protocol DebugMenuOption {
    
    var name: String { get }
    var title: String { get }
}

// The notification we'll send when a shake gesture happens.
extension UIDevice {
    static let deviceDidShakeNotification = Notification.Name(rawValue: "deviceDidShakeNotification")
}

// Override the default behavior of shake gestures to send our notification instead.
extension UIWindow {
     open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            NotificationCenter.default.post(name: UIDevice.deviceDidShakeNotification, object: nil)
        }
     }
}

// A view modifier that detects shaking and calls a function of our choosing.
struct DeviceShakeViewModifier: ViewModifier {
    let action: () -> Void

    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.deviceDidShakeNotification)) { _ in
                action()
            }
    }
}

struct DebugMenuViewModifier: ViewModifier {
    
    @State private var isDebugMenuPresented = false
    
    let options: [DebugMenuOption]
    
    func body(content: Content) -> some View {
        content
            .sheet(isPresented: $isDebugMenuPresented) {
                DebugMenuView(viewModel: DebugMenuViewModel(options: options))
            }
            .onShake {
                #if targetEnvironment(simulator)
                isDebugMenuPresented = true
                #endif
            }
    }
}

// A View extension to make the modifier easier to use.

extension View {
    func onShake(perform action: @escaping () -> Void) -> some View {
        self.modifier(DeviceShakeViewModifier(action: action))
    }
    
    public func attachDebugMenu(options: [DebugMenuOption]) -> some View {
        self.modifier(DebugMenuViewModifier(options: options))
    }
}
