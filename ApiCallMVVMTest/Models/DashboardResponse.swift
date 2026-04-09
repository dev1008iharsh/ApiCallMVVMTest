//
//  Untitled 4.swift
//  ApiCallMVVMTest
//
//  Created by Harsh on 09/04/26.
//
import Foundation

// This represents full API response
struct DashboardResponse: Codable {
    let title: String
    let description: String
    let users: [User]
    let stats: Stats
}

// Each user object
struct User: Codable {
    let id: Int
    let name: String
    let email: String
}

// Stats object (nested JSON)
struct Stats: Codable {
    let totalUsers: Int
    let activeUsers: Int
}
