//
//  SlidingTabBar.swift
//  FitnessUI
//
//  Created by Jack Moseley on 04/11/2024.
//

import SwiftUI

// Protocol for SlidingTab to define title
public protocol SlidingTab: View {
    var title: String { get }
}

// Define a result builder to handle multiple tabs
@resultBuilder
struct SlidingTabBuilder {
    static func buildBlock<Content: SlidingTab>(_ components: Content...) -> [Content] {
        components
    }
}

// SlidingTabItem to represent each tab's content and title
public struct SlidingTabItem<Content: View>: SlidingTab {
    public let title: String
    let content: Content
    
    init(_ title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    public var body: some View {
        content
    }
}

// Main SlidingTabView that uses the result builder to create multiple tabs
public struct SlidingTabView<TabContent: SlidingTab>: View {
    @State private var currentTab: Int = 0
    private let tabItems: [TabContent]
    private var isScrollable: Bool = true
    
    init(@SlidingTabBuilder content: () -> [TabContent]) {
        self.tabItems = content()
    }
    init(
        isScrollable: Bool,
        @SlidingTabBuilder content: () -> [TabContent]
    ) {
        self.isScrollable = isScrollable
        self.tabItems = content()
    }
    
    public var body: some View {
        ZStack(alignment: .top) {
            TabView(selection: $currentTab) {
                ForEach(0..<tabItems.count, id: \.self) { index in
                    tabItems[index]
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .edgesIgnoringSafeArea(.all)
            
            TabBarView(
                currentTab: $currentTab,
                tabBarOptions: tabItems.map { $0.title },
                isScrollable: isScrollable
            )
        }
    }
}

// Custom TabBarView to display tab titles as buttons
private struct TabBarView: View {
    @Namespace private var namespace
    
    @Binding var currentTab: Int
    let tabBarOptions: [String]
    let isScrollable: Bool
    
    var body: some View {
        Group {
            if isScrollable {
                ScrollView(.horizontal, showsIndicators: false) {
                    tabBarItems
                }
            } else {
                HStack(spacing: 0) {
                    tabBarItems
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .background(Color.white)
        .frame(height: 80)
        .edgesIgnoringSafeArea(.all)
    }
    
    // Tab bar items extracted for clarity
    private var tabBarItems: some View {
        HStack(spacing: isScrollable ? 20 : 0) {
            ForEach(Array(tabBarOptions.enumerated()), id: \.0) { index, name in
                TabBarItem(
                    currentTab: $currentTab,
                    namespace: namespace,
                    tabBarItemName: name,
                    tab: index
                )
            }
        }
        .padding(.horizontal, isScrollable ? 10 : 0)
    }
}

// TabBarItem for each individual tab title button in the TabBarView
private struct TabBarItem: View {
    @Binding var currentTab: Int
    let namespace: Namespace.ID
    
    var tabBarItemName: String
    var tab: Int
    
    var body: some View {
        Button(action: {
            self.currentTab = tab
        }) {
            VStack {
                Spacer()
                Text(tabBarItemName)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(currentTab == tab ? .black : .gray)
                if currentTab == tab {
                    Color.black
                        .frame(height: 2)
                        .matchedGeometryEffect(id: "underline", in: namespace, properties: .frame)
                } else {
                    Color.clear.frame(height: 2)
                }
            }
            .animation(.spring(), value: self.currentTab)
        }
        .buttonStyle(.plain)
    }
}

#Preview("Scrollable Sliding Tab View") {
    SlidingTabView {
        SlidingTabItem("Longer Tab Title") {
            Text("First Tab Content")
        }
        SlidingTabItem("Short Tab") {
            Text("Second Tab Content")
        }
        SlidingTabItem("Standard Tab") {
            Text("Second Tab Content")
        }
        SlidingTabItem("A longer final tab") {
            Text("Third Tab Content")
        }
    }
}

#Preview("Non-Scrollable Sliding Tab View") {
    SlidingTabView(isScrollable: false) {
        SlidingTabItem("First Tab") {
            Text("First Tab Content")
        }
        SlidingTabItem("Second Tab") {
            Text("Second Tab Content")
        }
        SlidingTabItem("Third Tab") {
            Text("Third Tab Content")
        }
    }
}
