# EmployeeHub - iOS Test Assignment

## Overview

EmployeeHub is an iOS application designed to manage and display a list of employees fetched from remote servers. It offers functionality such as searching, viewing detailed information on each employee, and the ability to refresh the employee list dynamically. The app is built using SwiftUI and adheres to modern iOS development practices.

## Requirements to Compile and Run

- **Xcode 14** or later: The project uses Swift 5.7 features that are supported in Xcode 14 and above.
- **Swift 5.7** or later: Ensure that the Swift version is up to date in your development environment.
- **iOS 16** or later: This version supports the latest SwiftUI features used in the app.
- **Active Internet connection**: Necessary to fetch employee data from the remote servers during runtime.

## Features

- **Employee Listing**: Displays employees grouped by their positions in alphabetical order. Each group's employees are also sorted alphabetically by last name.
- **Detailed Employee View**: Offers a detailed view for each employee, including personal and contact information, and a list of projects.
- **Search Functionality**: Allows filtering the employee list based on names, positions, or projects.
- **Dynamic Data Refresh**: Supports pull-to-refresh to reload data from the remote servers.
- **Robust Error Handling**: Manages network failures and alerts the user to any issues with data fetching.

## Architecture

EmployeeHub uses the **Model-View-ViewModel (MVVM)** architecture pattern, which enhances the separation of concerns by dividing the application into three interconnected components:

- **Model**: Handles the raw data (employees), parsing JSON from the network responses.
- **View**: Responsible for presenting user interface elements and receiving user interactions.
- **ViewModel**: Acts as a liaison that manages the communication between the Model and the View by handling business logic and updating the UI state.

This architecture was chosen to facilitate easier maintenance and testing of the application, promoting a clean organizational structure.

## Data Fetching

The application fetches employee data simultaneously from two distinct endpoints:
- **Tallinn Employee List**: [https://tallinn-jobapp.aw.ee/employee_list](https://tallinn-jobapp.aw.ee/employee_list)
- **Tartu Employee List**: [https://tartu-jobapp.aw.ee/employee_list](https://tartu-jobapp.aw.ee/employee_list)

Using the `NetworkManager`, the app makes concurrent requests to these endpoints and aggregates the responses. This approach ensures efficient data retrieval and processing.

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/codexprojects/employeedirectory.git
   cd EmployeeHub
2. Open the project in Xcode:
   ```bash
   open EmployeeHub.xcodeproj
3. Build and run the app on the iOS Simulator.
