//
//  NetworkClient.swift
//  SmartHome
//
//  Created by Stanislav on 22.04.2023.
//

import Foundation

enum ApiError: Error {
    case invalidURL
}

enum HttpMethod: String {
    case post = "POST"
    case get = "GET"
    case delete = "DELETE"
}

protocol NetworkClient {
    func requestDecodable<Response: Decodable>(_ urlRequest: URLRequest) async throws -> Response
}

final class ApiClient: NetworkClient {
    
    private let session = URLSession.shared
    
    func requestDecodable<Response: Decodable>(_ urlRequest: URLRequest) async throws -> Response {
        let (data, _) = try await session.data(for: urlRequest)
        return try JSONDecoder().decode(Response.self, from: data)
    }
}
