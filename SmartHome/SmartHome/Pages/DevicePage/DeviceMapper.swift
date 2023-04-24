//
//  DeviceMapper.swift
//  SmartHome
//
//  Created by Stanislav on 22.04.2023.
//

import Foundation

final class DeviceMapper {
    static func makeDeviceCellModel(deviceType: DeviceType) -> DeviceCellModel {
        switch deviceType {
        case .light(let light):
            let state = LightState(isOn: light.isOn, intensity: Float(light.intensity))
            return DeviceCellModel(id: light.id, title: light.deviceName, state: state)
            
        case .heater(let heater):
            let state = HeaterState(isOn: heater.isOn, temp: Float(heater.temperature))
            return DeviceCellModel(id: heater.id, title: heater.deviceName, state: state)
            
        case .roller(let roller):
            let state = RollerState(position: Float(roller.position))
            return DeviceCellModel(id: roller.id, title: roller.deviceName, state: state)
        }
    }
}
