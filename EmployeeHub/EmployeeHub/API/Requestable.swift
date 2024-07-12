//
//  NetworkManager.swift
//  EmployeeHub
//
//  Created by Ilke Yucel on 12.07.2024.
//

import Foundation
import Combine

public protocol Requestable {
    var requestTimeOut: Float { get }
    
    func request<T: Codable>(_ request: RequestModel) -> AnyPublisher<T, NetworkError>
}

public struct RequestModel {
    let endpoints: Endpoints
    let body: Data?
    let requestTimeOut: Float?
    
    public init(endpoints: Endpoints, requestBody: Encodable? = nil, requestTimeOut: Float? = nil) {
        self.endpoints = endpoints
        self.body = requestBody?.encodedToData()
        self.requestTimeOut = requestTimeOut
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

