//
//  EmployeeService.swift
//  EmployeeHub
//
//  Created by Ilke Yucel on 12.07.2024.
//

import Combine
import Foundation

/// Service class for fetching employee data.
class EmployeeService {
    private var networkRequest: Requestable
    
    /// Initializes the service with a network request handler.
    init(networkRequest: Requestable) {
        self.networkRequest = networkRequest
    }
    
    /// Fetches the list of employees from both Tallinn and Tartu endpoints concurrently.
    func fetchList() async throws -> [Employee] {
        let tallinnEndpoint = EmployeeServiceEndpoints.tallinnEmployeeList
        let tartuEndpoint = EmployeeServiceEndpoints.tartuEmployeeList
        
        // Perform both requests concurrently and wait for both to complete.
        async let tallinnEmployees: [Employee] = fetchEmployees(endpoint: tallinnEndpoint)
        async let tartuEmployees: [Employee] = fetchEmployees(endpoint: tartuEndpoint)
        
        // Combine the results from both endpoints.
        return try await tallinnEmployees + tartuEmployees
    }
    
    /// Fetches employees from a specific endpoint.
    private func fetchEmployees(endpoint: Endpoint) async throws -> [Employee] {
        let request = RequestModel(endpoints: endpoint)
        do {
            let response: EmployeeResponse = try await networkRequest.request(request)
            return response.employees
        } catch {
            // Rethrow the error to be handled by the caller.
            throw error
        }
    }
}
