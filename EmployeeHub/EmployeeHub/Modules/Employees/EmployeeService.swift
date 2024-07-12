//
//  EmployeeService.swift
//  EmployeeHub
//
//  Created by Ilke Yucel on 12.07.2024.
//

import Foundation
import Combine

// Use Combine to fetch and combine lists in parallel more efficiently.
class EmployeeService {
    private var networkRequest: Requestable
    
    init(networkRequest: Requestable) {
        self.networkRequest = networkRequest
    }
    
    func fetchList() -> AnyPublisher<[Employee], NetworkError> {
        let tallinnPublisher = fetchEmployees(from: .tallinnEmployeeList)
        let tartuPublisher = fetchEmployees(from: .tartuEmployeeList)
        
        // Use zip to combine the results of both publishers into a single publisher that emits a tuple of their outputs.
        return Publishers.Zip(tallinnPublisher, tartuPublisher)
            .map { tallinnEmployees, tartuEmployees in
                // Combine the arrays of employees from both locations into a single array.
                return tallinnEmployees + tartuEmployees
            }
            .eraseToAnyPublisher()
    }
    
    private func fetchEmployees(from endpoint: EmployeeServiceEndpoints) -> AnyPublisher<[Employee], NetworkError> {
        let request = RequestModel(endpoints: endpoint)
        return networkRequest.request(request)
            .map { (response: EmployeeResponse) in response.employees }
            .eraseToAnyPublisher()
    }
}
