//
//  DevicesViewModel.swift
//  SmartHome
//
//  Created by Stanislav on 19.04.2023.
//

import Foundation
import Combine

final class DevicesViewModel {
    enum State: Equatable {
        case loading
        case loaded([DeviceCellModel])
        case error(String)
        case empty
    }
    
    let title: String
    let provider: DevicePageProvider
    let onCellAction = PassthroughSubject<DeviceCellModel, Never>()
    
    @Published var state: State = .loaded([])
    
    init(manager: DevicePageProvider) {
        self.title = NSLocalizedString("devices", tableName: "Device", comment: "")
        self.provider = manager
    }
    
    func fetchDevices() {
        guard state != .loading else { return }
        provider.updateStorage(deviceModels: [])
        state = .loading
        
        Task.init {
            do {
                let response = try await provider.fetchDevicePage()
                let models = response.devices.map(DeviceMapper.makeDeviceCellModel)
                provider.updateStorage(deviceModels: models)
                state = provider.deviceModels.isEmpty ? .empty : .loaded(provider.deviceModels)
            } catch {
                provider.updateStorage(deviceModels: [])
                let errorDescription = NSLocalizedString("general.error.description", tableName: "Device", comment: "")
                state = .error(errorDescription)
            }
        }
    }
    
    func updateDevice(deviceModel: DeviceCellModel) {
        provider.updateDevice(deviceModel: deviceModel)
        state = .loaded(provider.deviceModels)
    }
}
