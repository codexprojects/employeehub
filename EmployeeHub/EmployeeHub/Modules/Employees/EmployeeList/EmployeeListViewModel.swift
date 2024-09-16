//
//  EmployeeViewModel.swift
//  EmployeeHub
//
//  Created by Ilke Yucel on 12.07.2024.
//

import Foundation
import Combine

/// ViewModel for managing the list of employees.
@MainActor
final class EmployeeListViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var groupedEmployees: [String: [Employee]] = [:]
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showErrorAlert: Bool = false
    @Published var searchText: String = ""
    
    // MARK: - Private Properties
    private var allEmployees: [Employee] = []
    private var cancellables = Set<AnyCancellable>()
    private let employeeService: EmployeeService
    
    // MARK: - Initialization
    /// Initializes the ViewModel with an employee service.
    init(employeeService: EmployeeService) {
        self.employeeService = employeeService
        Task {
            await fetchEmployees()
        }
        setupSearch()
    }
    
    // MARK: - Fetching Data
    /// Fetches employees and updates the UI accordingly.
    @MainActor
    func fetchEmployees() async {
        isLoading = true
        do {
            let employees = try await employeeService.fetchList()
            let unifiedEmployees = unifyAndMergeEmployees(employees)
            allEmployees = unifiedEmployees // Update allEmployees with the fetched and processed employees
            groupAndSortEmployees(unifiedEmployees)
        } catch {
            errorMessage = error.localizedDescription
            showErrorAlert = true
        }
        isLoading = false
    }
    
    // MARK: - Data Processing
    /// Unifies and merges duplicate employees based on their names.
    private func unifyAndMergeEmployees(_ employees: [Employee]) -> [Employee] {
        var uniqueEmployees: [String: Employee] = [:]
        
        for employee in employees {
            let key = "\(employee.fname.lowercased())-\(employee.lname.lowercased())"
            if var existingEmployee = uniqueEmployees[key] {
                existingEmployee.mergeProjects(from: employee)
                uniqueEmployees[key] = existingEmployee
            } else {
                uniqueEmployees[key] = employee
            }
        }
        
        return Array(uniqueEmployees.values)
    }
    
    /// Groups and sorts employees by their position and last name.
    @MainActor
    private func groupAndSortEmployees(_ employees: [Employee]) {
        // Group the employees by their position
        let grouped = Dictionary(grouping: employees, by: { $0.position })
        
        // Sort each group first by first name, and if they are the same, then by last name
        groupedEmployees = grouped.mapValues { group in
            group.sorted {
                if $0.fname == $1.fname {
                    return $0.lname < $1.lname  // If first names are the same, sort by last name
                } else {
                    return $0.fname < $1.fname  // Otherwise, sort by first name
                }
            }
        }
    }
    
    // MARK: - Search Functionality
    /// Sets up the search functionality with debounce to minimize processing.
    private func setupSearch() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                let processedText = searchText.lowercased()
                Task {
                    [weak self] in
                    guard let strongSelf = self else { return }
                    await strongSelf.filterEmployees(with: processedText)
                }
            }
            .store(in: &cancellables)
    }
    
    /// Filters employees based on the search text.
    @MainActor
    private func filterEmployees(with searchText: String) async {
        if searchText.isEmpty {
            groupAndSortEmployees(allEmployees)
        } else {
            let filtered = allEmployees.filter {
                $0.fname.lowercased().contains(searchText) ||
                $0.lname.lowercased().contains(searchText) ||
                $0.position.lowercased().contains(searchText) ||
                $0.projects?.contains(where: { $0.lowercased().contains(searchText) }) ?? false
            }
            groupAndSortEmployees(filtered)
        }
    }
    
    // MARK: - Actions
    /// Refreshes the employee list.
    func refresh() async {
        await fetchEmployees()
    }
}

// MARK: - Employee Extension
/// Extension to merge projects of duplicate employees.
extension Employee {
    mutating func mergeProjects(from other: Employee) {
        let combinedProjects = (self.projects ?? []) + (other.projects ?? [])
        self.projects = Array(Set(combinedProjects)).sorted()
    }
}
