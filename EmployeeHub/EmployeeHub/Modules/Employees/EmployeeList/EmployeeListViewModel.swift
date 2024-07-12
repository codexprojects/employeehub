//
//  EmployeeViewModel.swift
//  EmployeeHub
//
//  Created by Ilke Yucel on 12.07.2024.
//

import Foundation
import Combine

class EmployeeListViewModel: ObservableObject {
    @Published var groupedEmployees: [String: [Employee]] = [:]
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showErrorAlert: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    private let employeeService: EmployeeService
    
    init(employeeService: EmployeeService) {
        self.employeeService = employeeService
        fetchEmployees() // Ensure data is fetched when the view model is initialized
    }
    
    func fetchEmployees() {
        isLoading = true
        employeeService.fetchList()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case let .failure(error) = completion {
                    self?.errorMessage = error.localizedDescription
                    self?.showErrorAlert = true
                    print("Error: \(error.localizedDescription)") // Debugging print
                }
            }, receiveValue: { [weak self] employees in
                print("Fetched employees: \(employees)") // Debugging print
                self?.groupAndSort(employees: employees)
            })
            .store(in: &cancellables)
    }
    
    private func groupAndSort(employees: [Employee]) {
        // First, sort the employees by last name, then by first name
        let sortedEmployees = employees.sorted { ($0.lname, $0.fname) < ($1.lname, $1.fname) }
        
        // Next, group the sorted employees by their position
        let grouped = Dictionary(grouping: sortedEmployees) { $0.position }
        
        // Print the grouped result for debugging
        print("Grouped employees: \(grouped)") // Debugging print
        
        // Then, sort each group's employees again (to ensure order within groups)
        let sortedGrouped = grouped.mapValues { group in
            group.sorted { ($0.lname, $0.fname) < ($1.lname, $1.fname) }
        }
        
        // Finally, sort the groups by their keys (positions) and convert to a [String: [Employee]] dictionary
        groupedEmployees = Dictionary(uniqueKeysWithValues: sortedGrouped.sorted { $0.key < $1.key })
    }
    
    func refresh() {
        fetchEmployees()
    }
}
