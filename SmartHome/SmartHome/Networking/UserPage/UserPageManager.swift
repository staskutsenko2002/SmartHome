//
//  UserPageManager.swift
//  SmartHome
//
//  Created by Stanislav on 22.04.2023.
//

import Foundation

final class UserPageManager: UserProvider {
    
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func fetchUserPage() async throws -> UserRequestResponse {
        guard let url = URL(string: "http://storage42.com/modulotest/data.json") else {
            throw ApiError.invalidURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HttpMethod.get.rawValue
        return try await networkClient.requestDecodable(urlRequest)
    }
}
