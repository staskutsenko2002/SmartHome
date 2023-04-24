//
//  RequestResponse.swift
//  SmartHome
//
//  Created by Stanislav on 22.04.2023.
//

import Foundation

struct DevicesRequestResponse: Decodable {
    let devices: [DeviceType]
}

struct UserRequestResponse: Decodable {
    let user: User
}
