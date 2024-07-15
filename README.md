# EmployeeHub - iOS Test Assignment

## Overview

The EmployeeHub is an iOS application that displays a list of employees fetched from remote servers. The app includes features such as pull-to-refresh, search functionality, and detailed views of each employee. It is implemented using SwiftUI.

## Requirements to Compile and Run

- Xcode 14 or later
- Swift 5.7 or later
- iOS 16 or later
- Internet connection (to fetch employee data from remote servers)

## Features

- Displays a list of employees grouped by their positions, sorted alphabetically.
- Allows users to view detailed information about each employee.
- Supports pull-to-refresh to reload the employee list.
- Includes a search bar to filter employees by first name, last name, position, and projects.
- Implements error handling for network failures.

## Architecture

The app follows the MVVM (Model-View-ViewModel) architecture pattern. This architecture was chosen for its clear separation of concerns, making the code more modular, testable, and maintainable. 

- **Model:** Represents the employee data and is responsible for decoding the JSON response from the server.
- **View:** Comprises SwiftUI views to display the UI.
- **ViewModel:** Manages the data and business logic, providing data to the views and handling user interactions.

## Data Fetching

Employee data is fetched from two remote endpoints simultaneously:

- [Tallinn Employee List](https://tallinn-jobapp.aw.ee/employee_list)
- [Tartu Employee List](https://tartu-jobapp.aw.ee/employee_list)

The data is fetched using the `NetworkManager` class, which makes parallel network requests to both endpoints and combines the results.

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/codexprojects/employeedirectory.git
   cd EmployeeHub
2. Open the project in Xcode:
   ```bash
   open EmployeeHub.xcodeproj
3. Build and run the app on the iOS Simulator.
