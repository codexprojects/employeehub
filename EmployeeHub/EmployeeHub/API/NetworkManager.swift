//
//  NetworkManager.swift
//  EmployeeHub
//
//  Created by Ilke Yucel on 12.07.2024.
//

import Foundation
import Combine

public class NetworkManager: Requestable {
    public var requestTimeOut: Float = 30
    
    public func request<T>(_ request: RequestModel) -> AnyPublisher<T, NetworkError> where T : Codable {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = TimeInterval(request.requestTimeOut ?? requestTimeOut)
        
        return URLSession.shared
            .dataTaskPublisher(for: request.getURLRequest()!)
            .tryMap { output in
                guard output.response is HTTPURLResponse else {
                    throw NetworkError.serverError(code: 0, error: "Server error")
                }
                return output.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                NetworkError.invalidJSON(String(describing: error))
            }
            .eraseToAnyPublisher()
        }
}