//
//  FoodInfoNetworking.swift
//  FitnessTrackerServices
//
//  Created by Jack Moseley on 10/11/2024.
//

import DependencyManagement
import Foundation

public protocol FoodInfoNetworking: Sendable {
    
    @Sendable func search(for barcode: String) async throws -> FoodProduct
}

public struct FoodInfoNetworkService: FoodInfoNetworking {
    
    public init() {}
    
    @Inject
    private var apiClient: ApiProtocol
    
    public func search(for barcode: String) async throws -> FoodProduct {
        
        let endpoint = FoodInfoEndpoints.getFoodInfo(barcode: barcode)
        
        let response = try await apiClient.asyncRequest(endpoint: endpoint, responseModel: FoodInfoResponse.self)
        
        guard let product = response.product else {
            throw ApiError.init(errorCode: "404", message: "Item not found")
        }
        
        return product
    }
}
