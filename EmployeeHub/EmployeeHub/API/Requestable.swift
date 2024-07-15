//
//  NetworkManager.swift
//  EmployeeHub
//
//  Created by Ilke Yucel on 12.07.2024.
//

import Foundation
import Combine

/// Defines the requirements for types that can perform network requests.
public protocol Requestable {
    /// Performs a network request and decodes the response into a specified `Codable` type.
    /// - Parameter request: The `RequestModel` containing the details of the request to be made.
    /// - Returns: A `Codable` object of type `T` representing the decoded response.
    /// - Throws: An error if the request fails or if the response cannot be decoded.
    func request<T: Codable>(_ request: RequestModel) async throws -> T
}

/// Represents the model for a network request, including the endpoint and optional request body.
public struct RequestModel {
    /// The endpoint for the network request.
    let endpoints: Endpoint
    /// The optional request body as `Data`.
    let body: Data?
    
    /// Initializes a new `RequestModel` with the specified endpoint and an optional request body.
    /// - Parameters:
    ///   - endpoints: The `Endpoint` for the network request.
    ///   - requestBody: An optional `Encodable` object to be used as the request body. Defaults to `nil`.
    public init(endpoints: Endpoint, requestBody: Encodable? = nil) {
        self.endpoints = endpoints
        self.body = requestBody?.encodedToData()
    }
    
    /// Constructs a `URLRequest` from the `RequestModel`.
    /// - Returns: An optional `URLRequest` configured with the endpoint's URL, HTTP method, headers, and request body. Returns `nil` if the URL cannot be constructed.
    func getURLRequest() -> URLRequest? {
        guard let url = endpoints.getURL() else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoints.method.rawValue
        endpoints.headers.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }
        request.httpBody = body
        return request
    }
}

/// Provides an extension for `Encodable` types to encode themselves to `Data`.
extension Encodable {
    /// Encodes the `Encodable` instance to `Data`.
    /// - Returns: The encoded `Data`, or `nil` if encoding fails.
    func encodedToData() -> Data? {
        let encoder = JSONEncoder()
        return try? encoder.encode(self)
    }
}
