//
//  DashboardViewModelTests.swift
//  ApiCallMVVMTest
//
//  Created by Harsh on 09/04/26.
//

@testable import ApiCallMVVMTest
import XCTest

final class DashboardViewModelTests: XCTestCase {
    // MARK: - Mock Service

    // Fake service to avoid real API call
    final class MockService: NetworkServiceProtocol {
        // Result type helps simulate success or failure
        var result: Result<DashboardResponse, Error>!

        func fetchDashboard() async throws -> DashboardResponse {
            print("🧪 MockService called")

            // Returns success or throws error
            return try result.get()
        }
    }

    // MARK: - SUCCESS TEST

    func testSuccess() async {
        print("🟢 testSuccess START")

        // 1. Arrange (prepare data)
        let mock = MockService()

        mock.result = .success(
            DashboardResponse(
                title: "Test",
                description: "Desc",
                users: [User(id: 1, name: "Ravi", email: "ravi@test.com")],
                stats: Stats(totalUsers: 1, activeUsers: 1)
            )
        )

        let vm = DashboardViewModel(service: mock)

        // expectation is used to wait for async result
        let exp = expectation(description: "Success state received")

        // 2. Observe state change
        vm.onStateChange = { state in

            print("📡 State received:", state)

            // Check only success case
            if case let .success(data) = state {
                print("✅ Success data received:", data)

                // 3. Assert (verify result)
                XCTAssertEqual(data.title, "Test")
                XCTAssertEqual(data.users.count, 1)

                exp.fulfill() // mark test as completed
            }
        }

        // 4. Act (call function)
        vm.fetch()

        // Wait for async operation
        await fulfillment(of: [exp], timeout: 1)

        print("🟢 testSuccess END")
    }

    // MARK: - FAILURE TEST

    func testFailure() async {
        print("🔴 testFailure START")

        let mock = MockService()

        // Simulate failure
        mock.result = .failure(NSError(domain: "TestError", code: 500))

        let vm = DashboardViewModel(service: mock)

        let exp = expectation(description: "Failure state received")

        vm.onStateChange = { state in

            print("📡 State received:", state)

            if case let .failure(error) = state {
                print("❌ Failure error:", error)

                exp.fulfill()
            }
        }

        vm.fetch()

        await fulfillment(of: [exp], timeout: 1)

        print("🔴 testFailure END")
    }
}
