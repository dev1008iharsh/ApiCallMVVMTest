//
//  DashboardViewModel.swift
//  ApiCallMVVMTest
//
//  Created by Harsh on 09/04/26.
//

import Foundation

final class DashboardViewModel {
    // Different states for UI
    enum State {
        case loading
        case success(DashboardResponse)
        case failure(String)
    }

    // Binding callback
    var onStateChange: ((State) -> Void)?

    private let service: NetworkServiceProtocol

    init(service: NetworkServiceProtocol = NetworkService()) {
        self.service = service
    }

    // Fetch data
    func fetch() {
        onStateChange?(.loading)

        Task {
            do {
                let data = try await service.fetchDashboard()
                onStateChange?(.success(data))

            } catch {
                onStateChange?(.failure(error.localizedDescription))
            }
        }
    }
}
