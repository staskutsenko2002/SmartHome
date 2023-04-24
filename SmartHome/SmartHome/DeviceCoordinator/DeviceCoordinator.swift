//
//  DeviceCoordinator.swift
//  SmartHome
//
//  Created by Stanislav on 24.04.2023.
//

import UIKit
import Combine

final class DeviceCoordinator {
    
    private lazy var navigationController = makeNavigationController()
    private var cancellables = Set<AnyCancellable>()
    
    func start() -> UIViewController {
        return navigationController
    }
    
    private func makeNavigationController() -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: makeDeviceViewController())
        self.navigationController = navigationController
        navigationController.navigationBar.prefersLargeTitles = true
        return navigationController
    }
    
    private func makeDeviceViewController() -> UIViewController {
        let manager = DevicePageManager(networkClient: ApiClient())
        let viewModel = DevicesViewModel(manager: manager)
        
        viewModel.onCellAction.sink { [weak self] deviceModel in
            guard let self else { return }
            self.pushDetailsViewController(deviceModel: deviceModel) { deviceModel in
                viewModel.updateDevice(deviceModel: deviceModel)
            }
        }.store(in: &cancellables)
        
        let viewController = DevicesViewController(viewModel: viewModel)
        return viewController
    }
    
    private func makeDetailsViewController(
        deviceModel: DeviceCellModel,
        updateModelAction: @escaping ((DeviceCellModel) -> Void)
    ) -> UIViewController {
        
        let viewModel = DetailsViewModel(deviceModel: deviceModel)
        viewModel.onCloseScreenAction.sink { model in
            updateModelAction(model)
        }.store(in: &cancellables)
        let viewController = DetailsViewController(viewModel: viewModel)
        return viewController
    }
    
    private func pushDetailsViewController(
        deviceModel: DeviceCellModel,
        updateModelAction: @escaping ((DeviceCellModel) -> Void)
    ) {
        let detailsViewController = makeDetailsViewController(
            deviceModel: deviceModel,
            updateModelAction: { deviceModel in
                updateModelAction(deviceModel)
            }
        )
        
        navigationController.pushViewController(detailsViewController, animated: true)
    }
}
