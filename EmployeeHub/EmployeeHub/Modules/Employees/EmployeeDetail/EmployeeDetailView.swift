//
//  EmployeeDetailView.swift
//  EmployeeHub
//
//  Created by Ilke Yucel on 12.07.2024.
//

import SwiftUI

struct EmployeeDetailView: View {
    let employee: Employee
    @Environment(\.presentationMode) var presentationMode
    
    init(employee: Employee) {
        self.employee = employee
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .leading) {
                Color(hex: "#161623").ignoresSafeArea(.all)
                
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
