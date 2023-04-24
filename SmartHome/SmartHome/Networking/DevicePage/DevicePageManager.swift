//
//  DevicePageManager.swift
//  SmartHome
//
//  Created by Stanislav on 21.04.2023.
//

import Foundation

final class DevicePageManager: DevicePageProvider {
    
    var deviceModels: [DeviceCellModel] = []
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func fetchDevicePage() async throws -> DevicesRequestResponse {
        guard let url = URL(string: "http://storage42.com/modulotest/data.json") else {
            throw ApiError.invalidURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HttpMethod.get.rawValue
        return try await networkClient.requestDecodable(urlRequest)
    }
    
    func updateStorage(deviceModels: [DeviceCellModel]) {
        self.deviceModels = deviceModels
    }
    
    func updateDevice(deviceModel: DeviceCellModel) {
        guard let index = deviceModels.firstIndex(where: { $0.id == deviceModel.id })
        else {
            return
        }
        
        deviceModels[index].state = deviceModel.state
    }
}
