import Foundation
import SwiftUI

struct WeightScrollerView: View {
    @State private var scrollId: Double?
    
    let itemWidth: CGFloat = 4
    let weights = stride(from: 30.0, to: 150.1, by: 0.1).map { $0 }
    
    var body: some View {
        VStack {
            Text("What is your current weight?")
                .font(.headline)
            
            let weight = "\(scrollId ?? 0)"
            Text("\(weight)kg")
                .font(.title3)
            
            ZStack {
                Rectangle()
                    .fill(Color.red)
                    .frame(width: 2, height: 80)
                    .zIndex(1)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack {
                        ForEach(weights, id: \.self) { weight in
                            if weight.truncatingRemainder(dividingBy: 1) == 0 {
                                VStack(spacing: 0) {
                                    // Vertical dash using Divider
                                    Divider()
                                        .frame(width: 1, height: 30)
                                        .background(Color.green)
                                    Text("\(Int(weight))")
                                        .font(.footnote)
                                        .foregroundColor(.gray)
                                        .lineLimit(1)
                                        .fixedSize(horizontal: true, vertical: false)
                                }
                                .frame(width: itemWidth)
                            } else {
                                
                                VStack {
                                    // Vertical dash using Divider
                                    Divider()
                                        .frame(width: 1, height: 20)
                                        .background(.gray)
                                        .padding([.top], 2)
                                    Text("")
                                        .font(.body)
                                }
                                .frame(width: itemWidth)
                            }
                        }
                    }
                    .scrollTargetLayout()
                }
                .scrollPosition(id: $scrollId)
                .scrollTargetBehavior(.viewAligned)
                .onChange(of: scrollId) { oldValue, newValue in
                    print(newValue ?? "")
                }
                .frame(maxHeight: 70)
            }
        }
    }
}
