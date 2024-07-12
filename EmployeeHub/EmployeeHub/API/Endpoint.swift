//
//  Endpoint.swift
//  EmployeeHub
//
//  Created by Ilke Yucel on 12.07.2024.
//

import Foundation

public protocol Endpoints {
    var baseURL: String { get }
    var path: String { get }
    var parameter: [URLQueryItem] { get }
    var headers: [String:String] { get }
    var method: HTTPMethod { get }
    
    func getURL() -> URL?
}

extension Endpoints {
    func getURL() -> URL? {
        var component = URLComponents()
        component.scheme = "https"
        component.host = baseURL
        component.path = path
        component.queryItems = parameter
        return component.url
    }
}
