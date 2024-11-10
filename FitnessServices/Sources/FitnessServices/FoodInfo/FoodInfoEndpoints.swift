//
//  File 2.swift
//  FitnessTrackerServices
//
//  Created by Jack Moseley on 10/11/2024.
//

import Foundation

enum FoodInfoEndpoints: EndpointProvider {

    case getFoodInfo(barcode: String)
    
    var baseURL: String {
        return "world.openfoodfacts.org"
    }

    var path: String {
        switch self {
        case .getFoodInfo(let barcode):
            return "/api/v3/product/\(barcode).json"
        }
    }

    var method: RequestMethod {
        switch self {
        case .getFoodInfo:
            return .get
        }
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case .getFoodInfo:
            return [URLQueryItem(name: "getFoodInfo", value: "code,product_name,nutriments")]
        }
    }

    var body: [String: Any]? {
        switch self {
        default:
            return nil
        }
    }

    var mockFile: String? {
        switch self {
        case .getFoodInfo:
            return "_getFoodInfoMockResponse"
        }
    }
}
