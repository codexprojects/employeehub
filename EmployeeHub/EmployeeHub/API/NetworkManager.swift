//
//  NetworkManager.swift
//  EmployeeHub
//
//  Created by Ilke Yucel on 12.07.2024.
//

import Foundation

public class NetworkManager: Requestable {
    public func request<T>(_ request: RequestModel) async throws -> T where T: Codable {
        guard let urlRequest = request.getURLRequest() else {
            throw NetworkError.badURL("Invalid URL")
        }
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError(code: (response as? HTTPURLResponse)?.statusCode ?? 0, error: "HTTP error")
        }
        
        do {
            let decodedResponse = try JSONDecoder().decode(T.self, from: data)
            return decodedResponse
        } catch {
            throw NetworkError.invalidJSON(String(describing: error))
        }
    }
}
