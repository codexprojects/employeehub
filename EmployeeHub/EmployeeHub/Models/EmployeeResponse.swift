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

struct Employee: Codable, Identifiable {
    var id: UUID = UUID()
    let fname: String
    let lname: String
    let position: String
    let contactDetails: ContactDetails?
    let projects: [String]?
    
    enum CodingKeys: String, CodingKey {
        case fname, lname, position, contactDetails = "contact_details", projects
    }
}

struct ContactDetails: Codable {
    let email: String?
    let phone: String?
}
