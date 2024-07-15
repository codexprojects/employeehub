# EmployeeHub - iOS Test Assignment

## Overview

EmployeeHub is an iOS application designed to manage and display a list of employees fetched from remote servers. It offers functionality such as searching, viewing detailed information on each employee, and refreshing the list dynamically. The app is built using SwiftUI and adheres to modern iOS development practices.

## Requirements to Compile and Run

- **Xcode 14** or later: The project uses Swift 5.7 features supported in Xcode 14 and above.
- **Swift 5.7** or later: Ensure the Swift version is current in your development environment.
- **iOS 16** or later: This version supports the latest SwiftUI features used in the app.
- **Active Internet connection**: Fetching employee data from the remote servers during runtime is necessary.

## Features

- **Employee Listing**: This displays employees grouped by their positions alphabetically. The employees in each group are also sorted alphabetically by last name.
- **Detailed Employee View**: This option offers a detailed view of each employee, including personal and contact information and a list of projects.
- **Search Functionality**: Allows filtering the employee list based on names, positions, or projects.
- **Dynamic Data Refresh**: Supports pull-to-refresh to reload data from the remote servers.
- **Robust Error Handling**: Manages network failures and alerts the user to any issues with data fetching.

## Architecture

EmployeeHub uses the **Model-View-ViewModel (MVVM)** architecture pattern, which enhances the separation of concerns by dividing the application into three interconnected components:

- **Model**: Handles the raw data (employees), parsing JSON from the network responses.
- **View**: Present user interface elements and receive user interactions.
- **ViewModel**: Acts as a liaison that manages the communication between the Model and the View by handling business logic and updating the UI state.

This architecture was chosen to facilitate easier maintenance and testing of the application, promoting a clean organizational structure.

## Data Fetching

The application fetches employee data simultaneously from two distinct endpoints:
- **Tallinn Employee List
- **Tartu Employee List
Using the `NetworkManager`, the app makes concurrent requests to these endpoints and aggregates the responses. This approach ensures efficient data retrieval and processing.

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/codexprojects/employeehub.git
   cd EmployeeHub
2. Open the project in Xcode:
   ```bash
   open EmployeeHub.xcodeproj
3. Build and run the app on the iOS Simulator.
