//
//  UserPageFetcher.swift
//  SmartHome
//
//  Created by Stanislav on 22.04.2023.
//

import Foundation

protocol UserProvider {
    func fetchUserPage() async throws -> UserRequestResponse
}
