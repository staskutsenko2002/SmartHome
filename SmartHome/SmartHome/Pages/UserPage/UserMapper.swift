//
//  UserMapper.swift
//  SmartHome
//
//  Created by Stanislav on 23.04.2023.
//

import UIKit

final class UserMapper {
    static func mapToUserModel(dateFormatter: DateFormatter, user: User) -> UserModel {
        let fullName = "\(user.firstName) \(user.lastName)"
        let date = Date(timeIntervalSince1970: TimeInterval(user.birthDate/1000))
        let birthdate = dateFormatter.string(from: date)
        let city = "\(user.address.city), \(user.address.country)"
        let address = "\(user.address.streetCode) \(user.address.street), \(user.address.postalCode)"
        return .init(avatar: UIImage(named: "UserAvatar"), name: fullName, birthDate: birthdate, city: city, address: address)
    }
}
