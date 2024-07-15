//
//  EmployeeServiceEndpoint.swift
//  EmployeeHub
//
//  Created by Ilke Yucel on 12.07.2024.
//

import Foundation

/// Enum representing the endpoints for employee services.
enum EmployeeServiceEndpoints: Endpoint {
    case tallinnEmployeeList
    case tartuEmployeeList
    
    /// Base URL for the endpoint.
    var baseURL: String {
        switch self {
            case .tallinnEmployeeList: "tallinn-jobapp.aw.ee"
            case .tartuEmployeeList: "tartu-jobapp.aw.ee"
        }
    }
    
    /// Path for the endpoint.
    var path: String {
        switch self {
            case .tallinnEmployeeList, .tartuEmployeeList: "/employee_list"
        }
    }
    
    /// HTTP method for the endpoint.
    var method: HTTPMethod {
        switch self {
            case .tartuEmployeeList, .tallinnEmployeeList: .get
        }
    }
}

