//
//  States.swift
//  SmartHome
//
//  Created by Stanislav on 22.04.2023.
//

import UIKit

protocol StateProtocol {
    var description: String { get }
    var image: UIImage? { get }
}

// MARK: - LightState
enum LightState: StateProtocol {
    case off(Float)
    case on(Float)
    case fullyOn
    
    var description: String {
        switch self {
        case .off:
            return NSLocalizedString("off", tableName: "Device", comment: "")
        case .on(let intensity):
            let localized = NSLocalizedString("on.at.intensity", tableName: "Device", comment: "")
            return String(format: localized, "\(Int(intensity))")
        case .fullyOn:
            return NSLocalizedString("fully.on", tableName: "Device", comment: "")
        }
    }
    
    var intensity: Float {
        switch self {
        case .fullyOn: return 100
        case .on(let intensity): return intensity
        case .off(let intensity): return intensity
        }
    }
    
    var isOn: Bool {
        switch self {
        case .on, .fullyOn: return true
        case .off: return false
        }
    }
    
    var maxIntensity: Float { 100 }
    
    var minIntensity: Float { 0 }
    
    var image: UIImage? {
        switch self {
        case .on, .fullyOn: return UIImage(named: "DeviceLightOnIcon")
        case .off: return UIImage(named: "DeviceLightOffIcon")
        }
    }
    
    init(isOn: Bool, intensity: Float) {
        switch isOn {
        case true: self = intensity == 100 ? .fullyOn : .on(intensity)
        case false: self = .off(intensity)
        }
    }
}

// MARK: - HeaterState
enum HeaterState: StateProtocol {
    case on(Float)
    case off(Float)
    
    var description: String {
        switch self {
        case .on(let temperature):
            let localized = NSLocalizedString("on.at.temp", tableName: "Device", comment: "")
            return String(format: localized, "\(temperature)")
        case .off:
            return NSLocalizedString("off", tableName: "Device", comment: "")
        }
    }
    
    var maxTemp: Float { 28 }
    var minTemp: Float { 7 }
    
    var isOn: Bool {
        switch self {
        case .on: return true
        case .off: return false
        }
    }
    
    var image: UIImage? {
        switch self {
        case .on: return UIImage(named: "DeviceHeaterOnIcon")
        case .off: return UIImage(named: "DeviceHeaterOffIcon")
        }
    }
    
    var temperature: Float {
        switch self {
        case .on(let temp): return temp
        case .off(let temp): return temp
        }
    }
    
    init(isOn: Bool, temp: Float) {
        switch isOn {
        case true: self = .on(temp)
        case false: self = .off(temp)
        }
    }
}

// MARK: - RollerState
enum RollerState: StateProtocol {
    case closed
    case opened(Float)
    case fullyOpened
    
    var position: Float {
        switch self {
        case .closed: return 0
        case .opened(let position): return Float(position)
        case .fullyOpened: return 100
        }
    }
    
    var maxPosition: Float { 100 }
    
    var minPosition: Float { 0 }
    
    var description: String {
        switch self {
        case .closed:
            return NSLocalizedString("closed", tableName: "Device", comment: "")
            
        case .opened(let percent):
            let localized = NSLocalizedString("opened.at", tableName: "Device", comment: "")
            return String(format: localized, "\(Int(percent))")
            
        case .fullyOpened:
            return NSLocalizedString("fully.opened", tableName: "Device", comment: "")
        }
    }
    
    var image: UIImage? {
        .init(named: "DeviceRollerShutterIcon")
    }
    
    init(position: Float) {
        switch position {
        case 0: self = .closed
        case 1..<100: self = .opened(position)
        case 100: self = .fullyOpened
        default: self = .closed
        }
    }
}
