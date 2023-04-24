//
//  DeviceType.swift
//  SmartHome
//
//  Created by Stanislav on 21.04.2023.
//

import Foundation

enum DeviceType: Decodable {
    case light(Light)
    case heater(Heater)
    case roller(Roller)
    
    enum CodingKeys: String, CodingKey {
        case productType
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let productType = try container.decode(String.self, forKey: .productType)
        
        switch productType {
        case "Light":
            let light = try Light(from: decoder)
            self = .light(light)
            
        case "Heater":
            let heater = try Heater(from: decoder)
            self = .heater(heater)
            
        case "RollerShutter":
            let roller = try Roller(from: decoder)
            self = .roller(roller)
            
        default:
            throw DecodingError.dataCorruptedError(forKey: .productType, in: container, debugDescription: "Unknown product type: \(productType)")
        }
    }
}
