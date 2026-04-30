import Foundation

final class DashboardViewModel {

    // MARK: - State

    /// Represents UI state (clean MVVM binding)
    enum State {
        case loading
        case success(DashboardResponse)
        case failure(String)
    }

    // MARK: - Properties

    var onStateChange: ((State) -> Void)?

    private let service: NetworkServiceProtocol

    /// Stored Task to control lifecycle (VERY IMPORTANT for cancellation)
    private var task: Task<Void, Never>?

    // MARK: - Init

    init(service: NetworkServiceProtocol = NetworkService()) {
        self.service = service
    }

    // MARK: - Fetch

    func fetch() {

        print("🟡 [ViewModel] Fetch called")

        onStateChange?(.loading)

        // Cancel any previous running request (avoid duplicate API calls)
        task?.cancel()

        task = Task { [weak self] in
            guard let self else { return }

            do {
                let data = try await service.fetchDashboard()

                // Prevent UI updates after cancellation
                try Task.checkCancellation()

                print("🟢 [ViewModel] Data received")

                await MainActor.run {
                    self.onStateChange?(.success(data))
                }

            } catch is CancellationError {
                // Cancellation is expected behavior (not an error)
                print("⚠️ [ViewModel] Task Cancelled")

            } catch {
                print("🔴 [ViewModel] Error:", error.localizedDescription)

                await MainActor.run {
                    self.onStateChange?(.failure(error.localizedDescription))
                }
            }
        }
    }

    // MARK: - Cancel

    func cancel() {
        print("🛑 [ViewModel] Cancel called")
        task?.cancel()
        task = nil
    }
}
