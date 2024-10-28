//
//  DairyFetching.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 30/10/2023.
//

import DependencyManagement
import FitnessPersistence
import Foundation
import SwiftData

protocol DiaryRepository {
    
    func diaryEntries(for day: Date) async throws -> [DiaryEntryDTO]
}

@ModelActor
actor LocalDiaryRepository: DiaryRepository {
    
    func diaryEntries(for day: Date) async throws -> [DiaryEntryDTO] {
        
        let descriptor = FetchDescriptor<DiaryEntry>(sortBy: [SortDescriptor(\.timestamp)])
        let entries = try modelContext.fetch(descriptor)
        let entryDtos = entries.map { DiaryEntryDTO(diaryEntry: $0) }
        
        return entryDtos
    }
}
