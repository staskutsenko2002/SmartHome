//
//  Light.swift
//  SmartHome
//
//  Created by Stanislav on 19.04.2023.
//

import Foundation

struct Light: Decodable {
    let id: Int
    let deviceName: String
    let intensity: Int
    let mode: String
    
    var isOn: Bool {
        mode == "ON"
    }
}
