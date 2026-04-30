import Foundation

/// Represents full dashboard API response
struct DashboardResponse: Codable {
    let title: String
    let description: String
    let users: [User]
    let stats: Stats
}

/// Represents single user item
struct User: Codable {
    let id: Int
    let name: String
    let email: String
}

/// Represents stats section from API
struct Stats: Codable {
    let totalUsers: Int
    let activeUsers: Int
}
