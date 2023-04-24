//
//  Heater.swift
//  SmartHome
//
//  Created by Stanislav on 21.04.2023.
//

import Foundation

struct Heater: Decodable {
    let id: Int
    let deviceName: String
    let mode: String
    let temperature: Int
    
    var isOn: Bool {
        mode == "ON"
    }
}
