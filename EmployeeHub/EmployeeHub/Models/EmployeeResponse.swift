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
    var id = UUID()
    let fname: String
    let lname: String
    let position: String
    let contactDetails: ContactDetails?
    var projects: [String]?

    enum CodingKeys: String, CodingKey {
        case fname, lname, position, contactDetails = "contact_details", projects
    }
    
    static let employeeList = [
        Employee(
            fname: "Eve",
            lname: "Morris",
            position: "IOS",
            contactDetails: ContactDetails(email: "eve.morris@example.com", phone: "456-789-0123"),
            projects: ["Project Nu", "Project Xi"]
        ),
        Employee(
            fname: "Frank",
            lname: "Clark",
            position: "Android",
            contactDetails: ContactDetails(email: "frank.clark@example.com"),
            projects: ["Project Omicron", "Project Pi"]
        ),
        Employee(
            fname: "Grace",
            lname: "Rodriguez",
            position: "Sales",
            contactDetails: ContactDetails(email: "grace.rodriguez@example.com", phone: "567-890-1234"),
            projects: ["Project Rho", "Project Sigma"]
        ),
        Employee(
            fname: "Henry",
            lname: "Lewis",
            position: "Tester",
            contactDetails: ContactDetails(email: "henry.lewis@example.com"),
            projects: ["Project Tau", "Project Upsilon"]
        ),
        Employee(
            fname: "Isla",
            lname: "Walker",
            position: "PM",
            contactDetails: ContactDetails(email: "isla.walker@example.com", phone: "678-901-2345"),
            projects: ["Project Phi", "Project Chi"]
        ),
        Employee(
            fname: "Jack",
            lname: "Allen",
            position: "Other",
            contactDetails: ContactDetails(email: "jack.allen@example.com"),
            projects: ["Project Psi", "Project Omega"]
        ),
        Employee(
            fname: "Jack",
            lname: "Allen",
            position: "Other",
            contactDetails: ContactDetails(email: "jack.allen@example.com"),
            projects: ["Project ririroiro", "Project vididi"]
        ),
        Employee(
            fname: "Katie",
            lname: "Young",
            position: "IOS",
            contactDetails: ContactDetails(email: "katie.young@example.com", phone: "789-012-3456"),
            projects: ["Project Alpha2", "Project Beta2"]
        ),
        Employee(
            fname: "Leo",
            lname: "Hill",
            position: "Android",
            contactDetails: ContactDetails(email: "leo.hill@example.com"),
            projects: ["Project Gamma2", "Project Delta2"]
        ),
        Employee(
            fname: "Mia",
            lname: "Scott",
            position: "Sales",
            contactDetails: ContactDetails(email: "mia.scott@example.com", phone: "890-123-4567"),
            projects: ["Project Epsilon2", "Project Zeta2"]
        ),
        Employee(
            fname: "Noah",
            lname: "Harris",
            position: "Tester",
            contactDetails: ContactDetails(email: "noah.harris@example.com"),
            projects: ["Project Eta2", "Project Theta2"]
        ),
        Employee(
            fname: "Olivia",
            lname: "Martinez",
            position: "PM",
            contactDetails: ContactDetails(email: "olivia.martinez@example.com", phone: "901-234-5678"),
            projects: ["Project Iota2", "Project Kappa2"]
        ),
        Employee(
            fname: "Paul",
            lname: "Davis",
            position: "Other",
            contactDetails: ContactDetails(email: "paul.davis@example.com"),
            projects: ["Project Lambda2", "Project Mu2"]
        ),
        Employee(
            fname: "Quinn",
            lname: "Lopez",
            position: "IOS",
            contactDetails: ContactDetails(email: "quinn.lopez@example.com", phone: "012-345-6789"),
            projects: ["Project Nu2", "Project Xi2"]
        ),
        Employee(
            fname: "Rose",
            lname: "Wilson",
            position: "Android",
            contactDetails: ContactDetails(email: "rose.wilson@example.com"),
            projects: ["Project Omicron2", "Project Pi2"]
        ),
        Employee(
            fname: "Sam",
            lname: "Evans",
            position: "Sales",
            contactDetails: ContactDetails(email: "sam.evans@example.com", phone: "123-456-7890"),
            projects: ["Project Rho2", "Project Sigma2"]
        ),
        Employee(
            fname: "Tina",
            lname: "Thomas",
            position: "Tester",
            contactDetails: ContactDetails(email: "tina.thomas@example.com"),
            projects: ["Project Tau2", "Project Upsilon2"]
        ),
        Employee(
            fname: "John",
            lname: "Doe",
            position: "IOS",
            contactDetails: ContactDetails(email: "john.doe@example.com", phone: "123-456-7890"),
            projects: ["Project Alpha", "Project Beta"]
        ),
        Employee(
            fname: "Jane",
            lname: "Smith",
            position: "Android",
            contactDetails: ContactDetails(email: "jane.smith@example.com", phone: "234-567-8901"),
            projects: ["Project Gamma", "Project Delta"]
        ),
        Employee(
            fname: "Alice",
            lname: "Johnson",
            position: "Sales",
            contactDetails: ContactDetails(email: "alice.johnson@example.com", phone: "345-678-9012"),
            projects: ["Project Epsilon", "Project Zeta"]
        ),
        Employee(
            fname: "Bob",
            lname: "Brown",
            position: "Tester",
            contactDetails: ContactDetails(email: "bob.brown@example.com"),
            projects: ["Project Eta", "Project Theta"]
        ),
        Employee(
            fname: "Carol",
            lname: "Davis",
            position: "PM",
            contactDetails: ContactDetails(email: "carol.davis@example.com", phone: "567-890-1234"),
            projects: ["Project Iota", "Project Kappa"]
        ),
        Employee(
            fname: "Dave",
            lname: "Wilson",
            position: "Other",
            contactDetails: ContactDetails(email: "dave.wilson@example.com"),
            projects: ["Project Lambda", "Project Mu"]
        )
    ]
}

struct ContactDetails: Codable {
    let email: String?
    var phone: String?
}
