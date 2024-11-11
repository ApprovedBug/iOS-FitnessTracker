//
//  Toast.swift
//  FitnessUI
//
//  Created by Jack Moseley on 11/11/2024.
//

import Foundation
import SwiftUI

struct ToastView: View {
    var message: String
    var onCancelTapped: (() -> Void)
  
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Text(message)
                .font(Font.callout)
                .foregroundColor(Color(UIColor.white))
        
            Spacer(minLength: 10)
        
            Button {
                onCancelTapped()
            } label: {
                Image(systemName: "xmark")
                    .foregroundColor(Color(UIColor.white))
            }
        }
        .padding()
        .frame(minWidth: 0, maxWidth: .infinity)
        .background(Color.accentColor)
        .cornerRadius(8)
        .padding(.horizontal, 16)
    }
}

struct Toast: ViewModifier {
    
    @Binding var isPresented: Bool
    @State private var workItem: DispatchWorkItem?
    
    let message: String
    
    func body(content: Content) -> some View {
        
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(
                ZStack {
                    mainToastView()
                        .offset(y: 32)
                }
                .animation(.easeOut(duration: 0.2), value: isPresented)
            )
            .onChange(of: isPresented) { newValue in
                showToast()
            }
    }
    
    @ViewBuilder
    func mainToastView() -> some View {
        
        if isPresented {
            VStack {
                Spacer()
                ToastView(
                    message: message
                ) {
                    dismissToast()
                }
                .padding([.bottom], 64)
            }
        }
    }
    
    func showToast() {
        guard isPresented else { return }
        
        UIImpactFeedbackGenerator(style: .light)
            .impactOccurred()
        
        let task = DispatchWorkItem {
            dismissToast()
        }
        
        workItem = task
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: task)
    }
    
    private func dismissToast() {
      withAnimation {
          isPresented = false
      }
      
      workItem?.cancel()
      workItem = nil
    }
}

extension View {
    
    public func toast(isPresented: Binding<Bool>, message: String) -> some View {
        modifier(Toast(isPresented: isPresented, message: message))
    }
}
