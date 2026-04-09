//
//  Untitled 3.swift
//  ApiCallMVVMTest
//
//  Created by Harsh on 09/04/26.
//
import Foundation

// Protocol for testability (important for unit testing)
protocol NetworkServiceProtocol {
    func fetchDashboard() async throws -> DashboardResponse
}

// Custom errors
enum NetworkError: LocalizedError {
    case fileNotFound
    case decodingFailed
    
    var errorDescription: String? {
        switch self {
        case .fileNotFound:
            return "Local JSON file not found"
        case .decodingFailed:
            return "Failed to decode data"
        }
    }
}

// Actual service
final class NetworkService: NetworkServiceProtocol {
    
    func fetchDashboard() async throws -> DashboardResponse {
        
        // Simulate API delay
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        // Get JSON file from app bundle
        guard let url = Bundle.main.url(forResource: "dashboard", withExtension: "json") else {
            throw NetworkError.fileNotFound
        }
        
        do {
            let data = try Data(contentsOf: url)
            
            // Decode JSON into model
            let decoded = try JSONDecoder().decode(DashboardResponse.self, from: data)
            return decoded
            
        } catch {
            print("❌ Decoding error:", error)
            throw NetworkError.decodingFailed
        }
    }
}
