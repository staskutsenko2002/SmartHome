//
//  User.swift
//  SmartHome
//
//  Created by Stanislav on 22.04.2023.
//

import Foundation

struct User: Decodable {
    let firstName: String
    let lastName: String
    let address: Address
    let birthDate: Int
}

struct Address: Decodable {
    let city: String
    let postalCode: Int
    let street: String
    let streetCode: String
    let country: String
}
