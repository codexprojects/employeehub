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
        Text(employee.fname)
    }
}

#Preview {
    let employee = Employee(fname: "Yucel", lname: "iOS Developer", position: "Developer", contactDetails: ContactDetails(email: "test@test.com", phone: "4444444"), projects: ["iOS"])
    return EmployeeDetailView(employee: employee)
}
