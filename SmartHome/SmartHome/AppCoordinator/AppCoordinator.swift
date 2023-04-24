//
//  AppCoordinator.swift
//  SmartHome
//
//  Created by Stanislav on 19.04.2023.
//

import UIKit

final class AppCoordinator {
    
    var tabBarController: UITabBarController
    
    private var window: UIWindow
    private lazy var deviceCoordinator = DeviceCoordinator()
    private lazy var userCoordinator = UserCoordinator()
    
    init(window: UIWindow) {
        self.window = window
        self.tabBarController = UITabBarController()
    }
    
    func start() {
        tabBarController = makeTabBarController()
        window.makeKeyAndVisible()
        window.rootViewController = tabBarController
    }
}

// MARK: - Private
private extension AppCoordinator {
    func makeTabBarController() -> TabBarController {
        return .init(
            items: [
                .init(controller: deviceCoordinator.start(), page: .devices),
                .init(controller: userCoordinator.start(), page: .user)
            ]
        )
    }
}
