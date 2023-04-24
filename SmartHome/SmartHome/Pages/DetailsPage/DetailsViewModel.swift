//
//  DetailsViewModel.swift
//  SmartHome
//
//  Created by Stanislav on 23.04.2023.
//

import Foundation
import Combine

final class DetailsViewModel {
    
    let title: String
    @Published var deviceModel: DeviceCellModel
    
    let onCloseScreenAction = PassthroughSubject<DeviceCellModel, Never>()
    
    init(deviceModel: DeviceCellModel) {
        self.title = NSLocalizedString("details", tableName: "Common", comment: "")
        self.deviceModel = deviceModel
    }
    
    func updateSlider(value: Float) {
        if let state = deviceModel.state as? HeaterState {
            let step: Float = 0.5
            let roundedValue: Float = round(value/step) * step
            deviceModel.state = HeaterState(isOn: state.isOn, temp: roundedValue)
        } else if let state = deviceModel.state as? LightState {
            let roundedValue: Float = round(value)
            deviceModel.state = LightState(isOn: state.isOn, intensity: roundedValue)
        } else if deviceModel.state is RollerState {
            let roundedValue: Float = round(value)
            deviceModel.state = RollerState(position: roundedValue)
        }
    }
    
    func updateSwitch(isOn: Bool) {
        if let state = deviceModel.state as? HeaterState {
            deviceModel.state = isOn ? HeaterState.on(state.temperature) : HeaterState.off(state.temperature)
        } else if let state = deviceModel.state as? LightState {
            deviceModel.state = isOn ? state.intensity == 100 ? LightState.fullyOn : LightState.on(state.intensity) : LightState.off(state.intensity)
        }
    }
}
