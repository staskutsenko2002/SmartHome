//
//  SmartHomeTests.swift
//  SmartHomeTests
//
//  Created by Stanislav on 23.04.2023.
//

@testable import SmartHome
import XCTest

final class SmartHomeTests: XCTestCase {

    func testUserMapping() throws {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        formatter.locale = Locale(identifier: "en_us")
        
        let address = Address(city: "New York", postalCode: 10100, street: "5th Avenue", streetCode: "225", country: "United States")
        let user = User(firstName: "Joe", lastName: "Doe", address: address, birthDate: 813766371000)
        
        let receivedModel = UserMapper.mapToUserModel(dateFormatter: formatter, user: user)
        let expectedModel = UserModel(avatar: nil, name: "Joe Doe", birthDate: "15 Oct 1995", city: "New York, United States", address: "225 5th Avenue, 10100")
        
        XCTAssert(receivedModel.name == expectedModel.name)
        XCTAssert(receivedModel.address == expectedModel.address)
        XCTAssert(receivedModel.birthDate == expectedModel.birthDate)
        XCTAssert(receivedModel.city == expectedModel.city)
        
    }
    
    func testRollerMapping() throws {
        let rollerFirst = Roller(id: 1, deviceName: "Roller - Kitchen", position: 30)
        let stateFirst = RollerState(position: rollerFirst.position)
        
        let localizedFirst = NSLocalizedString("opened.at", tableName: "Device", comment: "")
        let expectedDescriptionFirst = String(format: localizedFirst, "30")
        XCTAssert(stateFirst.description == expectedDescriptionFirst)
        
        let rollerSecond = Roller(id: 2, deviceName: "Roller - Kitchen", position: 0)
        let stateSecond = RollerState(position: rollerSecond.position)
        
        let expectedDescriptionSecond = NSLocalizedString("closed", tableName: "Device", comment: "")
        XCTAssert(stateSecond.description == expectedDescriptionSecond)
        
        let rollerThird = Roller(id: 2, deviceName: "Roller - Kitchen", position: 100)
        let stateThird = RollerState(position: rollerThird.position)
        
        let expectedDescriptionThird = NSLocalizedString("fully.opened", tableName: "Device", comment: "")
        XCTAssert(stateThird.description == expectedDescriptionThird)
    }
    
    func testHeaterMapping() throws {
        let heaterFirst = Heater(id: 1, deviceName: "Heater - Bedroom", mode: "ON", temperature: 60)
        let stateFirst = HeaterState(mode: heaterFirst.mode, temp: heaterFirst.temperature)
        
        let localizedFirst = NSLocalizedString("on.at.temp", tableName: "Device", comment: "")
        let expectedDescriptionFirst = String(format: localizedFirst, "60")
        XCTAssert(stateFirst.description == expectedDescriptionFirst)
        
        let heaterSecond = Heater(id: 2, deviceName: "Heater - Living room", mode: "OFF", temperature: 20)
        let stateSecond = HeaterState(mode: heaterSecond.mode, temp: heaterSecond.temperature)
        
        let expectedDescriptionSecond = NSLocalizedString("off", tableName: "Device", comment: "")
        XCTAssert(stateSecond.description == expectedDescriptionSecond)
    }
    
    func testLightMapping() throws {
        let lightFirst = Light(id: 1, deviceName: "Lamp - Dining Room", intensity: 60, mode: "ON")
        let stateFirst = LightState(intensity: lightFirst.intensity)
        
        let localizedFirst = NSLocalizedString("on.at.intensity", tableName: "Device", comment: "")
        let expectedDescriptionFirst = String(format: localizedFirst, "60")
        XCTAssert(stateFirst.description == expectedDescriptionFirst)
        
        let lightSecond = Light(id: 2, deviceName: "Lamp - Entrance", intensity: 100, mode: "ON")
        let stateSecond = LightState(intensity: lightSecond.intensity)
        
        let expectedDescriptionSecond = NSLocalizedString("fully.on", tableName: "Device", comment: "")
        XCTAssert(stateSecond.description == expectedDescriptionSecond)
        
        let lightThird = Light(id: 3, deviceName: "Lamp - Bedroom", intensity: 0, mode: "NO")
        let stateThird = LightState(intensity: lightThird.intensity)
        
        let expectedDescriptionThird = NSLocalizedString("off", tableName: "Device", comment: "")
        XCTAssert(stateThird.description == expectedDescriptionThird)
    }
}
