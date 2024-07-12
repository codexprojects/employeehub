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
    @Published var filteredEmployees: [Employee] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showErrorAlert: Bool = false
    @Published var searchText: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    private let employeeService: EmployeeService
    private var allEmployees: [Employee] = []
    
    init(employeeService: EmployeeService) {
        self.employeeService = employeeService
        fetchEmployees()
        setupSearch()
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
                }
            }, receiveValue: { [weak self] employees in
                print("Fetched employees: \(employees)")
                self?.allEmployees = employees
                self?.groupedEmployees = self?.groupAndSort(employees: employees) ?? [:]
            })
            .store(in: &cancellables)
    }
    
    private func setupSearch() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                self?.filterEmployees(with: searchText)
            }
            .store(in: &cancellables)
    }
    
    private func filterEmployees(with searchText: String) {
        guard !searchText.isEmpty else {
            groupedEmployees = groupAndSort(employees: allEmployees)
            return
        }
        
        let filtered = allEmployees.filter { employee in
            employee.fname.lowercased().contains(searchText.lowercased()) ||
            employee.lname.lowercased().contains(searchText.lowercased()) ||
            employee.position.lowercased().contains(searchText.lowercased()) ||
            employee.projects?.contains(where: { $0.lowercased().contains(searchText.lowercased()) }) ?? false
        }
        groupedEmployees = groupAndSort(employees: filtered)
    }
    
    private func groupAndSort(employees: [Employee]) -> [String: [Employee]] {
        let sortedEmployees = employees.sorted { ($0.lname, $0.fname) < ($1.lname, $1.fname) }
        let grouped = Dictionary(grouping: sortedEmployees) { $0.position }
        let sortedGrouped = grouped.mapValues { group in
            group.sorted { ($0.lname, $0.fname) < ($1.lname, $1.fname) }
        }
        return Dictionary(uniqueKeysWithValues: sortedGrouped.sorted { $0.key < $1.key })
    }
    
    func refresh() {
        fetchEmployees()
    }
}
