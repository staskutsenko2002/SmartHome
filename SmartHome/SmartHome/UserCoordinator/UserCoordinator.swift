//
//  UserCoordinator.swift
//  SmartHome
//
//  Created by Stanislav on 24.04.2023.
//

import UIKit

final class UserCoordinator {
    
    private lazy var navigationController = makeNavigationController()
    
    func start() -> UIViewController {
        return navigationController
    }
    
    private func makeNavigationController() -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: makeUserViewController())
        navigationController.navigationBar.prefersLargeTitles = true
        return navigationController
    }
    
    private func makeUserViewController() -> UIViewController {
        let manager = UserPageManager(networkClient: ApiClient())
        let viewModel = UserViewModel(manager: manager)
        return UserViewController(viewModel: viewModel)
    }
}
