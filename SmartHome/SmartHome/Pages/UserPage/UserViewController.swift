//
//  UserViewController.swift
//  SmartHome
//
//  Created by Stanislav on 22.04.2023.
//

import UIKit
import Combine

final class UserViewController: UIViewController {
    
    private var cancellables = Set<AnyCancellable>()
    private let viewModel: UserViewModel
    
    private var stateView: PageStateView?
    private let profileImageView = UIImageView()
    private let labelStackView = UIStackView()
    private let nameLabel = UILabel()
    private let birthDateLabel = UILabel()
    private let cityLabel = UILabel()
    private let addressLabel = UILabel()
    
    init(viewModel: UserViewModel) {
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
        viewModel.fetchUser()
    }
}

// MARK: - Setup Methods
private extension UserViewController {
    func setupUI() {
        view.backgroundColor = .white
        setupProfileImageView()
        setupRightButton()
        setupStackView()
        setupLabels()
        setupLayout()
    }
    
    func setupLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            profileImageView.heightAnchor.constraint(equalToConstant: 60),
            profileImageView.widthAnchor.constraint(equalTo: profileImageView.heightAnchor),
            profileImageView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 60),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            labelStackView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 50),
            labelStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            labelStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    func setupProfileImageView() {
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.layer.cornerRadius = 30
        profileImageView.image = UIImage(systemName: "person.crop.circle")
        profileImageView.layer.borderColor = UIColor.black.cgColor
        profileImageView.tintColor = .black
        profileImageView.layer.borderWidth = 2
        view.addSubview(profileImageView)
    }
    
    func setupStackView() {
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        labelStackView.spacing = 20
        labelStackView.axis = .vertical
        view.addSubview(labelStackView)
    }
    
    func setupLabels() {
        [nameLabel, birthDateLabel, cityLabel, addressLabel].forEach { label in
            label.font = .systemFont(ofSize: 20, weight: .bold)
            label.translatesAutoresizingMaskIntoConstraints = false
            labelStackView.addArrangedSubview(label)
        }
        
        setString("-", toLabel: nameLabel, withKey: "name", table: "User")
        setString("-", toLabel: birthDateLabel, withKey: "birthdate", table: "User")
        setString("-", toLabel: cityLabel, withKey: "city", table: "User")
        setString("-", toLabel: addressLabel, withKey: "address", table: "User")
    }
    
    func setString(_ string: String, toLabel label: UILabel, withKey key: String, table: String) {
        let localized = NSLocalizedString(key, tableName: table, comment: "")
        label.text = String(format: localized, string)
    }
    
    func setupRightButton() {
        let button = UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise"), style: .plain, target: self, action: #selector(didPressRefresh))
        navigationItem.setRightBarButton(button, animated: false)
    }
    
    func setupSubscription() {
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.handle(state)
            }.store(in: &cancellables)
    }
    
    func handle(_ state: UserViewModel.State) {
        hideStateView()
        
        switch state {
        case .loading:
            startLoading()
            [profileImageView, nameLabel, cityLabel, addressLabel, birthDateLabel].forEach({ $0.isHidden = true })
            
        case .loaded(let model):
            profileImageView.image = model.avatar
            setString(model.name, toLabel: nameLabel, withKey: "name", table: "User")
            setString(model.birthDate, toLabel: birthDateLabel, withKey: "birthdate", table: "User")
            setString(model.city, toLabel: cityLabel, withKey: "city", table: "User")
            setString(model.address, toLabel: addressLabel, withKey: "address", table: "User")
            [profileImageView, nameLabel, cityLabel, addressLabel, birthDateLabel].forEach({ $0.isHidden = false })
            
        case .error(let message):
            profileImageView.image = nil
            [profileImageView, nameLabel, cityLabel, addressLabel, birthDateLabel].forEach({ $0.isHidden = true })
            showError(title: message)
        }
    }
}

// MARK: - StateView methods
private extension UserViewController {
    func startLoading() {
        let loadingView = PageStateView()
        loadingView.state = .init(title: NSLocalizedString("loading", tableName: "Common", comment: ""), action: nil)
        showStateView(loadingView)
    }
    
    func showError(title: String) {
        let errorView = PageStateView()
        errorView.state = .init(
            title: title,
            action: .init(title: NSLocalizedString("refresh", tableName: "Common", comment: ""), onAction: { [weak self] in
                self?.hideStateView()
                self?.viewModel.fetchUser()
            }))
        showStateView(errorView)
    }
    
    func showStateView(_ stateView: PageStateView) {
        stateView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stateView)
        self.stateView = stateView
        
        NSLayoutConstraint.activate([
            stateView.topAnchor.constraint(equalTo: view.topAnchor),
            stateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stateView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func hideStateView() {
        stateView?.removeFromSuperview()
        stateView = nil
    }
    
    @objc func didPressRefresh() {
        viewModel.fetchUser()
    }
}
