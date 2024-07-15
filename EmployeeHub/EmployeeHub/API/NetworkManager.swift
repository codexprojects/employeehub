//
//  NetworkManager.swift
//  EmployeeHub
//
//  Created by Ilke Yucel on 12.07.2024.
//

import Foundation

/// A class responsible for managing network requests conforming to `Requestable`.
public class NetworkManager: Requestable {
    /// Performs a network request and decodes the response into a specified `Codable` type.
    /// - Parameter request: The `RequestModel` containing the details of the request to be made.
    /// - Returns: A `Codable` object of type `T` representing the decoded response.
    /// - Throws: `NetworkError` if the request fails at any point (bad URL, server error, or invalid JSON response).
    public func request<T>(_ request: RequestModel) async throws -> T where T: Codable {
        // Ensure the request can be constructed into a valid URLRequest.
        guard let urlRequest = request.getURLRequest() else {
            throw NetworkError.badURL("Invalid URL")
        }
        
        // Attempt to perform the request and capture the data and response.
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        // Verify the response is an HTTPURLResponse and the status code indicates success.
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError(code: (response as? HTTPURLResponse)?.statusCode ?? 0, error: "HTTP error")
        }
        
        // Attempt to decode the response data into the expected Codable type.
        do {
            let decodedResponse = try JSONDecoder().decode(T.self, from: data)
            return decodedResponse
        } catch {
            throw NetworkError.invalidJSON(String(describing: error))
        }
    }
}
