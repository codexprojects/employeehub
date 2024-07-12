//
//  EmployeeResponse.swift
//  EmployeeHub
//
//  Created by Ilke Yucel on 12.07.2024.
//

import Foundation

struct EmployeeResponse: Codable {
    let employees: [Employee]
}

struct Employee: Codable, Identifiable, Hashable {
    var id: UUID = UUID()
    let fname: String
    let lname: String
    let position: String
    let contactDetails: ContactDetails
    var projects: [String]?
    
    enum CodingKeys: String, CodingKey {
        case fname, lname, position, contactDetails = "contact_details", projects
    }
    
    mutating func merge(with other: Employee) {
        if let otherProjects = other.projects {
            self.projects = (self.projects ?? []) + otherProjects
        }
    }
}

struct ContactDetails: Codable, Hashable {
    let email: String
    let phone: String?
}
