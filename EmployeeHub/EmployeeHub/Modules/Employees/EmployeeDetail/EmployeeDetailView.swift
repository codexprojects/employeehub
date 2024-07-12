//
//  EmployeeDetailView.swift
//  EmployeeHub
//
//  Created by Ilke Yucel on 12.07.2024.
//

import SwiftUI

struct EmployeeDetailView: View {
    let employee: Employee
    
    var body: some View {
        VStack {
            if let projects = employee.projects {
                Text(projects.joined(separator: ", "))
                    .font(.title)
                    .padding()
            }
            Text(employee.fname + employee.lname)
                .font(.title)
                .padding()
            Text(employee.position)
        }
        
    }
}

#Preview {
    let employee = Employee(fname: "Yucel", lname: "iOS Developer", position: "Developer", contactDetails: ContactDetails(email: "test@test.com", phone: "4444444"), projects: ["iOS"])
    return EmployeeDetailView(employee: employee)
}
