//
//  KeyedDecodingContainer.swift
//  FitnessServices
//
//  Created by Jack Moseley on 13/11/2024.
//

import Foundation

extension KeyedDecodingContainer {
    // Decode a value as Double, handling both String and Double types
    func decodeToDouble(forKey key: Key) throws -> Double? {
        if let doubleValue = try? decode(Double.self, forKey: key) {
            return doubleValue
        } else if let stringValue = try? decode(String.self, forKey: key), let doubleValue = Double(stringValue) {
            return doubleValue
        }
        return nil
    }

    // Decode a value as Int, handling both String and Int types
    func decodeToInt(forKey key: Key) throws -> Int? {
        if let intValue = try? decode(Int.self, forKey: key) {
            return intValue
        } else if let stringValue = try? decode(String.self, forKey: key), let intValue = Int(stringValue) {
            return intValue
        }
        return nil
    }
}
