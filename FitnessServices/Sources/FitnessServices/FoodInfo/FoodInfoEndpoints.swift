//
//  File 2.swift
//  FitnessTrackerServices
//
//  Created by Jack Moseley on 10/11/2024.
//

import Foundation

enum FoodInfoEndpoints: EndpointProvider {

    case getFoodInfo(barcode: String)
    case search(searchTerm: String)
    
    var baseURL: String {
        return "world.openfoodfacts.org"
    }

    var path: String {
        switch self {
        case .getFoodInfo(let barcode):
            return "/api/v3/product/\(barcode).json"
        case .search:
            return "/cgi/search.pl"
        }
    }

    var method: RequestMethod {
        switch self {
        case .getFoodInfo, .search:
            return .get
        }
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case .getFoodInfo:
            return [URLQueryItem(name: "fields", value: "code,product_name,nutriments,serving_quantity,serving_quantity_unit,brands")]
        case .search(let searchTerm):
            return [
                URLQueryItem(name: "fields", value: "code,product_name,nutriments,serving_quantity,serving_quantity_unit,brands"),
                URLQueryItem(name: "json", value: "1"),
                URLQueryItem(name: "page_size", value: "20"),
                URLQueryItem(name: "sort_by", value: "popularity_key"),
                URLQueryItem(name: "search_terms", value: searchTerm),
                URLQueryItem(name: "no_cache", value: "1")
            ]
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
        case .search:
            return "_searchResponse"
        }
    }
}
