import Foundation

/// Protocol abstraction for testability (mocking आसान बने)
protocol NetworkServiceProtocol {
    func fetchDashboard() async throws -> DashboardResponse
}

/// Custom error types (clear debugging + user readable errors)
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

/// Actual service implementation
final class NetworkService: NetworkServiceProtocol {

    func fetchDashboard() async throws -> DashboardResponse {

        print("🟡 [Network] Start fetching...")

        // Simulate API delay (this is cancellable)
        try await Task.sleep(nanoseconds: 1_000_000_000)

        // Important: Stop execution if task already cancelled
        try Task.checkCancellation()

        guard let url = Bundle.main.url(forResource: "dashboard", withExtension: "json") else {
            print("🔴 [Network] File not found")
            throw NetworkError.fileNotFound
        }

        let data = try Data(contentsOf: url)

        // Check cancellation before heavy work (decoding)
        try Task.checkCancellation()

        do {
            let decoded = try JSONDecoder().decode(DashboardResponse.self, from: data)

            print("🟢 [Network] Decoding success")
            return decoded

        } catch {
            print("🔴 [Network] Decoding failed:", error)
            throw NetworkError.decodingFailed
        }
    }
}
