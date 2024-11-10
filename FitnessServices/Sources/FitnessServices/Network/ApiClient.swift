//
//  ApiProtocol.swift
//  FitnessTrackerServices
//
//  Created by Jack Moseley on 10/11/2024.
//

import Foundation

public protocol ApiProtocol: Sendable {
    
    @Sendable func asyncRequest<T: Decodable>(endpoint: EndpointProvider, responseModel: T.Type) async throws -> T
}

public final class ApiClient: ApiProtocol {
    
    public init() {}
    
    // 1
    var session: URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.waitsForConnectivity = true
        configuration.timeoutIntervalForRequest = 60 // seconds that a task will wait for data to arrive
        configuration.timeoutIntervalForResource = 300 // seconds for whole resource request to complete ,.
        return URLSession(configuration: configuration)
    }
    
    public func asyncRequest<T>(endpoint: any EndpointProvider, responseModel: T.Type) async throws -> T where T : Decodable {
        let (data, response) = try await session.data(for: endpoint.asURLRequest())
        return try self.manageResponse(data: data, response: response)
    }
    
    private func manageResponse<T: Decodable>(data: Data, response: URLResponse) throws -> T {
        guard let response = response as? HTTPURLResponse else {
            throw ApiError(
                errorCode: "ERROR-0",
                message: "Invalid HTTP response"
            )
        }
        switch response.statusCode {
        case 200...299:
            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                print("‼️", error)
                throw ApiError(
                    errorCode: "400",
                    message: "Error decoding data"
                )
            }
        default:
            guard let decodedError = try? JSONDecoder().decode(ApiError.self, from: data) else {
                throw ApiError(
                    statusCode: response.statusCode,
                    errorCode: "ERROR-0",
                    message: "Unknown backend error"
                )
            }
            if response.statusCode == 403 {
//                NotificationCenter.default.post(name: .terminateSession, object: self)
            }
            throw ApiError(
                statusCode: response.statusCode,
                errorCode: decodedError.errorCode,
                message: decodedError.message
            )
        }
    }
}
