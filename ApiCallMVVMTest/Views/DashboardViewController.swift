//
//  DashboardViewController.swift
//  ApiCallMVVMTest
//
//  Created by Harsh on 09/04/26.
//
import UIKit

final class DashboardViewController: UIViewController {
    // MARK: - Properties

    private let viewModel = DashboardViewModel()
    private var users: [User] = []

    private enum Constants {
        static let cellIdentifier = "cell"
    }

    // MARK: - UI

    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let statsLabel = UILabel()
    private let tableView = UITableView()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
        viewModel.fetch()

        title = "Dashboard"
    }

    // MARK: - Binding

    private func bind() {
        viewModel.onStateChange = { [weak self] state in
            guard let self else { return }

            DispatchQueue.main.async {
                self.handle(state)
            }
        }
    }

    private func handle(_ state: DashboardViewModel.State) {
        switch state {
        case .loading:
            print("🔄 Loading...")

        case let .success(data):
            updateUI(data)

        case let .failure(error):
            print("❌ Error:", error)
        }
    }

    // MARK: - UI Update

    private func updateUI(_ data: DashboardResponse) {
        titleLabel.text = data.title
        descriptionLabel.text = data.description
        statsLabel.text = "Total: \(data.stats.totalUsers) | Active: \(data.stats.activeUsers)"

        users = data.users
        tableView.reloadData()
    }

    // MARK: - UI Setup

    private func setupUI() {
        view.backgroundColor = .systemBackground

        titleLabel.font = .boldSystemFont(ofSize: 22)
        descriptionLabel.font = .systemFont(ofSize: 16)
        statsLabel.font = .systemFont(ofSize: 14)

        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.cellIdentifier)

        let stack = UIStackView(arrangedSubviews: [
            titleLabel,
            descriptionLabel,
            statsLabel,
            tableView,
        ])

        stack.axis = .vertical
        stack.spacing = 12

        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

// MARK: - TableView

extension DashboardViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = users[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath)

        var content = cell.defaultContentConfiguration()
        content.text = user.name
        content.secondaryText = user.email

        cell.contentConfiguration = content

        return cell
    }
}
