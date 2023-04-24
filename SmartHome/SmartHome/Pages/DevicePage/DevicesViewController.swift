//
//  DevicesViewController.swift
//  SmartHome
//
//  Created by Stanislav on 19.04.2023.
//

import UIKit
import Combine

final class DevicesViewController: UIViewController {
    
    private let viewModel: DevicesViewModel
    private let tableView = UITableView()
    private let refreshControl = UIRefreshControl()
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: DevicesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        title = viewModel.title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupSubscription()
        viewModel.fetchDevices()
    }
}

// MARK: - Setup functions
private extension DevicesViewController {
    func setupUI() {
        view.backgroundColor = .white
        setupLayout()
        setupTableView()
    }
    
    func setupLayout() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.refreshControl = refreshControl
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(DeviceTableViewCell.self)
        
        refreshControl.contentMode = .scaleAspectFit
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
    }
    
    func setupSubscription() {
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.handle(state)
            }.store(in: &cancellables)
    }
    
    func handle(_ state: DevicesViewModel.State) {
        hideStateView()

        switch state {
        case .empty:
            tableView.reloadData()
            showEmptyView()
            refreshControl.endRefreshing()
            
        case .loading:
            tableView.reloadData()
            startLoading()

        case .loaded:
            tableView.reloadData()
            refreshControl.endRefreshing()

        case .error(let message):
            tableView.reloadData()
            showError(title: message)
            refreshControl.endRefreshing()
        }
    }
}

// MARK: - StateView methods
private extension DevicesViewController {
    func startLoading() {
        let loadingView = PageStateView()
        loadingView.state = .init(title: NSLocalizedString("loading", tableName: "Common", comment: ""), action: nil)
        showStateView(loadingView)
    }

    func showEmptyView() {
        let emptyView = PageStateView()
        emptyView.state = .init(title: NSLocalizedString("no.devices.yet", tableName: "Common", comment: ""), action: nil)
        showStateView(emptyView)
    }

    func showError(title: String) {
        let errorView = PageStateView()
        errorView.state = .init(
            title: title,
            action: .init(title: NSLocalizedString("refresh", tableName: "Common", comment: ""), onAction: { [weak self] in
                self?.hideStateView()
                self?.viewModel.fetchDevices()
            }))
        showStateView(errorView)
    }

    func showStateView(_ stateView: PageStateView) {
        tableView.backgroundView = stateView
    }

    func hideStateView() {
        tableView.backgroundView?.removeFromSuperview()
        tableView.backgroundView = nil
    }
}

// MARK: - Selectors
@objc
private extension DevicesViewController {
    func didPullToRefresh() {
        viewModel.fetchDevices()
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension DevicesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.onCellAction.send(viewModel.provider.deviceModels[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.provider.deviceModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(DeviceTableViewCell.self, for: indexPath)
        cell.setup(cellModel: viewModel.provider.deviceModels[indexPath.row])
        return cell
    }
}
