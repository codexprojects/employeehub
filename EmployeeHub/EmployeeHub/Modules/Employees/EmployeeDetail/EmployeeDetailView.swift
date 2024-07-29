//
//  EmployeeDetailView.swift
//  EmployeeHub
//
//  Created by Ilke Yucel on 12.07.2024.
//

import SwiftUI

// MARK: - EmployeeDetailView
/// EmployeeDetailView: A SwiftUI view that presents detailed information about an employee.
/// It includes personal information, contact details, and a list of projects the employee has worked on.
struct EmployeeDetailView: View {
    // MARK: - Properties and Initializer
    /// - Parameters:
    ///   - employee: The `Employee` instance whose details are to be displayed.
    let employee: Employee
    @Environment(\.presentationMode) var presentationMode
    
    init(employee: Employee) {
        self.employee = employee
    }
    
    // MARK: - Body
    /// The body of `EmployeeDetailView` consists of a `NavigationStack` that contains a `ZStack` for layout.
    /// The `ZStack` aligns its children leading and uses a `VStack` to vertically arrange the header and detail list views.
    var body: some View {
        NavigationStack {
            ZStack(alignment: .leading) {
                Color.offsetBlack.ignoresSafeArea(.all)
                
                VStack(alignment: .leading) {
                    EmployeeDetailHeaderView(presentationMode: self._presentationMode)
                        .padding(.top, 16)
                    
                    EmployeeDetailListView(employee: self.employee)
                }
            }
        }
    }
}

#Preview {
    let employee = Employee(fname: "Ilke", lname: "Yucel", position: "iOS", contactDetails: ContactDetails(email: "test@test.com", phone: "4444444"), projects: ["Mooncascade", "Oz Consulting", "Plus-Zap", "Fasetrax", "Sailsaolight", "Zaam-Eco", "Roundhotstrong", "Alpha Sing", "Zonenix"])
    return EmployeeDetailView(employee: employee)
}

// MARK: - EmployeeDetailHeaderView
/// EmployeeDetailHeaderView: A view at the top of `EmployeeDetailView` that displays the title and a dismiss button.
struct EmployeeDetailHeaderView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        HStack {
            Text("Employee Details")
                .foregroundStyle(.white)
                .padding(.leading, 16)
                .font(.title)
            
            Spacer()
            
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .foregroundStyle(.white)
                    .frame(width:44, height: 44)
            }
            .padding(.trailing, 24)
        }
    }
}

// MARK: - EmployeeDetailListView
/// EmployeeDetailListView: A scrollable view that displays the employee's personal and contact information, as well as a list of projects.
struct EmployeeDetailListView: View {
    let employee: Employee
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                SectionView(title: "Personal Info", content: [
                    ("First Name", employee.fname),
                    ("Last Name", employee.lname),
                    ("Position", employee.position)
                ])
                
                SectionView(title: "Contact Info", content: [
                    ("Email", employee.contactDetails?.email ?? "-"),
                    employee.contactDetails?.phone.map { ("Phone", $0) } ?? ("", "")
                ].filter { !$0.0.isEmpty })
                
                if let projects = employee.projects, !projects.isEmpty {
                    let projectsJoined = projects.joined(separator: "   ")
                    let projectContent = [("", projectsJoined)]
                    SectionView(title: "Worked On", content: projectContent)
                }
            }
            .padding(32)
        }
        .foregroundColor(.white)
    }
}

// MARK: - SectionView
/// SectionView: A reusable view for displaying a section of information in `EmployeeDetailListView`.
/// It takes a title and a content array where each item is a tuple of label and data.
struct SectionView: View {
    var title: String
    var content: [(label: String, data: String)]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            VStack(alignment: .leading, spacing: 8) {
                Text(title.uppercased()).font(.subheadline)
                Rectangle().fill(.white).frame(height: 1)
            }
            ForEach(content, id: \.data) { item in
                HStack {
                    if !item.label.isEmpty {
                        Text(item.label)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text(item.data)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    } else {
                        Text(item.data)
                    }
                    
                }
            }
        }
        .padding(.bottom, 8)
    }
}
