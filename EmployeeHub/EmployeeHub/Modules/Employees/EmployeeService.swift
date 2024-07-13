//
//  EmployeeService.swift
//  EmployeeHub
//
//  Created by Ilke Yucel on 12.07.2024.
//

import Combine
import Foundation

class EmployeeService {
    private var networkRequest: Requestable
    
    init(networkRequest: Requestable) {
        self.networkRequest = networkRequest
    }
    
    // Updated to use async/await instead of Combine
    func fetchList() async throws -> [Employee] {
        let tallinnEndpoint = EmployeeServiceEndpoints.tallinnEmployeeList
        let tartuEndpoint = EmployeeServiceEndpoints.tartuEmployeeList
        
        // Perform both requests concurrently and wait for both to complete
        async let tallinnEmployees: [Employee] = fetchEmployees(endpoint: tallinnEndpoint)
        async let tartuEmployees: [Employee] = fetchEmployees(endpoint: tartuEndpoint)
        
        // Combine the results from both endpoints
        return try await tallinnEmployees + tartuEmployees
    }
    
    // Updated to use async/await
    private func fetchEmployees(endpoint: Endpoint) async throws -> [Employee] {
        let request = RequestModel(endpoints: endpoint)
        do {
            let response: EmployeeResponse = try await networkRequest.request(request)
            return response.employees
        } catch {
            // Rethrow the error to be handled by the caller
            throw error
        }
    }
}

