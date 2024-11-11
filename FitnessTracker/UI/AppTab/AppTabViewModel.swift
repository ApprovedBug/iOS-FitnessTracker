//
//  AppTabViewModel.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 11/11/2024.
//

import Foundation

@Observable
class AppTabViewModel {
    
    enum TabType {
        case diary
        case exercise
        case weight
        case account
    }
    
    struct TabItem: Identifiable, Hashable {
        let id = UUID()
        let title: String
        let image: String
        let tabType: TabType
    }
    
    var tabs: [TabItem]
    
    let diaryViewModel: DiaryViewModel
    
    @MainActor
    init() {
        tabs = [
            .init(title: "Diary", image: "list.bullet.clipboard", tabType: .diary),
            .init(title: "Exercise", image: "dumbbell", tabType: .exercise),
            .init(title: "Weight", image: "chart.xyaxis.line", tabType: .weight),
            .init(title: "Account", image: "person.crop.circle", tabType: .account)
        ]
        diaryViewModel = DiaryViewModel()
    }
}
