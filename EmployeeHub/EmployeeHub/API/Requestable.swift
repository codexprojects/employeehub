//
//  NetworkManager.swift
//  EmployeeHub
//
//  Created by Ilke Yucel on 12.07.2024.
//

import Foundation
import Combine

public protocol Requestable {
    func request<T: Codable>(_ request: RequestModel) -> AnyPublisher<T, NetworkError>
}

public struct RequestModel {
    let endpoints: Endpoints
    let body: Data?
    
    public init(endpoints: Endpoints, requestBody: Encodable? = nil) {
        self.endpoints = endpoints
        self.body = requestBody?.encodedToData()
    }
    
    func getURLRequest() -> URLRequest? {
        guard let url = endpoints.getURL() else {
            return nil
        }
        
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = endpoints.method.rawValue
        for header in endpoints.headers {
            request.addValue(header.value, forHTTPHeaderField: header.key)
        }
        return request
    }
}

extension Encodable {
    func encodedToData() -> Data? {
        let encoder = JSONEncoder()
        return try? encoder.encode(self)
    }
}

