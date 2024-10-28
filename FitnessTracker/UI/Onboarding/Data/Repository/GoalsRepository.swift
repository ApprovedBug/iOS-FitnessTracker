//
//  GoalsRepository.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 06/04/2024.
//

import DependencyManagement
import FitnessPersistence
import Foundation
import SwiftData

enum GoalsError: Error {
    case fetchError
}

protocol GoalsRepository {
    
    func goalsForUser(userId: String) async throws -> GoalsDTO
    func saveGoals(goalsDto: GoalsDTO, for user: String) async
}

@ModelActor
actor LocalGoalsRepository: GoalsRepository {
    
    func goalsForUser(userId: String) async throws -> GoalsDTO {
        let descriptor = FetchDescriptor<Goals>()
        guard let goals = try modelContext.fetch(descriptor).first else {
            fatalError("Could not featch goals")
        }
        let goalsDto = GoalsDTO(goals: goals)
        
        return goalsDto
    }
    
    func saveGoals(goalsDto: GoalsDTO, for user: String) async {
        
        let goals = Goals(
            kcal: goalsDto.kcal,
            carbs: goalsDto.carbs,
            protein: goalsDto.protein,
            fats: goalsDto.fats
        )
        
        modelContext.insert(goals)
        try? modelContext.save()
    }
}
