//
//  DevicePageProvider.swift
//  SmartHome
//
//  Created by Stanislav on 21.04.2023.
//

import Foundation

protocol DevicePageProvider {
    var deviceModels: [DeviceCellModel] { get set }
    
    func fetchDevicePage() async throws -> DevicesRequestResponse
    func updateStorage(deviceModels: [DeviceCellModel])
    func updateDevice(deviceModel: DeviceCellModel)
}
