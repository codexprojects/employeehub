//
//  EmployeeService.swift
//  EmployeeHub
//
//  Created by Ilke Yucel on 12.07.2024.
//

import Foundation
import Combine

class EmployeeService {
    private var networkRequest: Requestable
    
    init(networkRequest: Requestable) {
        self.networkRequest = networkRequest
    }
    
    func fetchList() -> AnyPublisher<[Employee], NetworkError> {
        let tallinnEndpoint = EmployeeServiceEndpoints.tallinnEmployeeList
        let tartuEndpoint = EmployeeServiceEndpoints.tartuEmployeeList
        
        let tallinnRequest = RequestModel(endpoints: tallinnEndpoint)
        let tartuRequest = RequestModel(endpoints: tartuEndpoint)
        
        let tallinnPublisher = networkRequest.request(tallinnRequest).map { (response: EmployeeResponse) in response.employees }.eraseToAnyPublisher()
        let tartuPublisher = networkRequest.request(tartuRequest).map { (response: EmployeeResponse) in response.employees }.eraseToAnyPublisher()
        
        return Publishers.Merge(tallinnPublisher, tartuPublisher)
            .collect()
            .map { responses in
                self.unifyEmployees(responses.flatMap { $0 })
            }
            .eraseToAnyPublisher()
    }
    
    private func unifyEmployees(_ employees: [Employee]) -> [Employee] {
        var uniqueEmployees: [String: Employee] = [:]
        
        for employee in employees {
            let key = "\(employee.fname) \(employee.lname)"
            if var existingEmployee = uniqueEmployees[key] {
                existingEmployee.merge(with: employee)
                uniqueEmployees[key] = existingEmployee
            } else {
                uniqueEmployees[key] = employee
            }
        }
        
        return Array(uniqueEmployees.values)
    }
}
