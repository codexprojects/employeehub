//
//  Endpoint.swift
//  EmployeeHub
//
//  Created by Ilke Yucel on 12.07.2024.
//

import Foundation

/// Defines the requirements for configuring network endpoints.
///
/// An endpoint represents a specific resource or operation in a web API. Implementing types
/// provide the necessary details to construct a URL request, such as the base URL, path,
/// parameters, headers, and the HTTP method.
public protocol Endpoint {
    /// The base URL of the endpoint, excluding any path components or parameters.
    /// For example, "api.example.com".
    var baseURL: String { get }
    
    /// The path component of the endpoint. Should be appended to the `baseURL`.
    /// For example, "/users".
    var path: String { get }
    
    /// A collection of query items (name-value pairs) to be included in the URL.
    /// These are typically used for request parameters.
    var parameter: [URLQueryItem] { get }
    
    /// A dictionary of HTTP header fields to be included in the request.
    var headers: [String: String] { get }
    
    /// The HTTP method (e.g., GET, POST) to be used for the request.
    var method: HTTPMethod { get }
    
    /// Constructs a `URL` instance from the endpoint's components.
    /// - Returns: An optional `URL` constructed from the endpoint's properties. Returns `nil` if the URL cannot be constructed.
    func getURL() -> URL?
}

/// Provides default implementations for parts of the `Endpoint` protocol.
extension Endpoint {
    /// Default query parameters. Override in conforming types to specify custom parameters.
    var parameter: [URLQueryItem] { [] }
    
    /// Default HTTP headers. Override in conforming types to specify custom headers.
    var headers: [String: String] { [:] }
    
    /// Constructs a `URL` using the endpoint's base URL, path, and parameters.
    /// - Returns: An optional `URL` constructed from the endpoint's properties. Returns `nil` if the URL cannot be constructed.
    func getURL() -> URL? {
        var component = URLComponents()
        component.scheme = "https" // Assumes HTTPS for all endpoints.
        component.host = baseURL
        component.path = path
        component.queryItems = parameter
        return component.url
    }
}
