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
    @Published var searchText: String = ""
    
    private var allEmployees: [Employee] = []
    private var cancellables = Set<AnyCancellable>()
    private let employeeService: EmployeeService
    
    init(employeeService: EmployeeService) {
        self.employeeService = employeeService
        Task {
            await fetchEmployees()
        }
        setupSearch()
    }
    
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
    
    @MainActor
    private func groupAndSortEmployees(_ employees: [Employee]) {
        let grouped = Dictionary(grouping: employees, by: { $0.position })
        groupedEmployees = grouped.mapValues { group in
            group.sorted { $0.lname < $1.lname }
        }
    }
    
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
    
    func refresh() async {
        await fetchEmployees()
    }
}

extension Employee {
    mutating func mergeProjects(from other: Employee) {
        let combinedProjects = (self.projects ?? []) + (other.projects ?? [])
        self.projects = Array(Set(combinedProjects))
    }
}
