//
//  EmployeeHubApp.swift
//  EmployeeHub
//
//  Created by Ilke Yucel on 12.07.2024.
//

import SwiftUI

@main
struct EmployeeHubApp: App {
    var body: some Scene {
        WindowGroup {
            let networkManager = NetworkManager()
            let employeeService = EmployeeService(networkRequest: networkManager)
            let employeeViewModel = EmployeeListViewModel(employeeService: employeeService)
            EmployeeListView(viewModel: employeeViewModel)
        }
    }
}
