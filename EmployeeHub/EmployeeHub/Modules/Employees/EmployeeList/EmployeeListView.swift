//
//  EmployeeListView.swift
//  EmployeeHub
//
//  Created by Ilke Yucel on 12.07.2024.
//

import SwiftUI

struct EmployeeListView: View {
    @StateObject var viewModel: EmployeeListViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $viewModel.searchText)
                    .padding(.horizontal)
                
                List {
                    ForEach(viewModel.groupedEmployees.keys.sorted(), id: \.self) { key in
                        Section(header: Text(key)) {
                            ForEach(viewModel.groupedEmployees[key] ?? [], id: \.id) { employee in
                                NavigationLink(destination: EmployeeDetailView(employee: employee)) {
                                    Text("\(employee.fname) \(employee.lname)")
                                }
                            }
                        }
                    }
                }
                .navigationTitle("Employees")
                .refreshable {
                    viewModel.refresh()
                }
                .alert("Error", isPresented: $viewModel.showErrorAlert, presenting: viewModel.errorMessage) { _ in
                    Button("OK", role: .cancel) { }
                } message: { errorMessage in
                    Text(errorMessage)
                }
            }
        }
        .onAppear {
            viewModel.fetchEmployees()
        }
    }
}

#Preview {
    let networkManager = NetworkManager()
    let employeeService = EmployeeService(networkRequest: networkManager)
    let employeeViewModel = EmployeeListViewModel(employeeService: employeeService)
    return EmployeeListView(viewModel: employeeViewModel)
}
