//
//  EmployeeServiceEndpoint.swift
//  EmployeeHub
//
//  Created by Ilke Yucel on 12.07.2024.
//

import Foundation

enum EmployeeServiceEndpoints: Endpoint {
    case tallinnEmployeeList
    case tartuEmployeeList
    
    var baseURL: String {
        switch self {
            case .tallinnEmployeeList: "tallinn-jobapp.aw.ee"
            case .tartuEmployeeList: "tartu-jobapp.aw.ee"
        }
    }
    
    var path: String {
        switch self {
            case .tallinnEmployeeList, .tartuEmployeeList: "/employee_list"
        }
    }
    
    var method: HTTPMethod {
        switch self {
            case .tartuEmployeeList, .tallinnEmployeeList: .get
        }
    }
}

