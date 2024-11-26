import FitnessUI
import Foundation
import SwiftUI
import UIKit

struct WeightScrollerView: View {
    
    @Environment(\.dismiss) var dismiss
    @State private var scrollId: Double?
    @State private var selectedWeight: String = ""
    @State var currentWeight: Double
    
    let itemWidth: CGFloat = 4
    let weights = stride(from: 30.0, to: 150.1, by: 0.1).map { $0 }
    var onWeightSelected: (Double) -> Void
    
    init(currentWeight: Double = 75, onWeightSelected: @escaping (Double) -> Void) {
        self.currentWeight = currentWeight
        self.onWeightSelected = onWeightSelected
    }
    
    var body: some View {
        VStack {
            Text("Please enter your current weight")
                .font(.headline)
                .padding()

            Text("\(selectedWeight)kg")
                .font(.title3)
            
            ZStack {
                Rectangle()
                    .fill(Color.red)
                    .frame(width: 2, height: 80)
                    .zIndex(1)
                ScrollViewReader { value in
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack {
                            ForEach(weights, id: \.self) { weight in
                                VStack(spacing: 0) {
                                    Divider()
                                        .frame(width: 1, height: 30)
                                        .background(weight.truncatingRemainder(dividingBy: 1) == 0 ? Color.green : Color.gray)
                                    
                                    Text(weight.truncatingRemainder(dividingBy: 1) == 0 ? "\(Int(weight))" : "")
                                        .font(.footnote)
                                        .foregroundColor(.gray)
                                        .lineLimit(1)
                                        .fixedSize(horizontal: true, vertical: false)
                                        .padding([.top], 4)
                                }
                                .frame(width: itemWidth)
                                .fixedSize()
                            }
                        }
                        .scrollTargetLayout()
                    }
                    .contentMargins(.horizontal, UIScreen.main.bounds.width / 2, for: .scrollContent)
                    .scrollPosition(id: $scrollId)
                    .scrollTargetBehavior(.viewAligned)
                    .onChange(of: scrollId) { oldValue, newValue in
                        if let newValue {
                            currentWeight = newValue
                            selectedWeight = String(format: "%.1f", newValue)
                            
                            let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
                            feedbackGenerator.prepare()
                            feedbackGenerator.impactOccurred()
                        }
                    }
                    .onAppear {
                        value.scrollTo(currentWeight)
                        selectedWeight = String(format: "%.1f", currentWeight)
                    }
                }
            }
            Button("Enter Weight") {
                onWeightSelected(currentWeight)
                dismiss()
            }
            .buttonStyle(RoundedButtonStyle())
            .padding()
        }
    }
}
