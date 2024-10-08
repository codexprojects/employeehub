//
//  EmployeeListView.swift
//  EmployeeHub
//
//  Created by Ilke Yucel on 12.07.2024.
//

import SwiftUI

// MARK: - EmployeeListView
// EmployeeListView: A SwiftUI view that displays a list of employees.
// It uses a ViewModel to manage the state and data for the list.
// The view includes a search bar for filtering employees and a detail view presented in a sheet.
struct EmployeeListView: View {
    @StateObject var viewModel: EmployeeListViewModel
    @State private var selectedEmployee: Employee?
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.offsetBlack
                    .ignoresSafeArea(.all)
                
                VStack {
                    CustomHeaderView(searchText: $searchText)
                        .frame(height: 188)
                        .cornerRadius(12)
                        .ignoresSafeArea(.all)
                        .padding(.bottom, -30)
                    
                    EmployeeList(viewModel: viewModel)
                }
            }
        }
        .sheet(item: $selectedEmployee) { employee in
            EmployeeDetailView(employee: employee)
        }
        .onChange(of: searchText) { newValue in
            viewModel.searchText = newValue
        }
    }
}

#Preview {
    let networkManager = NetworkManager()
    let employeeService = EmployeeService(networkRequest: networkManager)
    let employeeViewModel = EmployeeListViewModel(employeeService: employeeService)
    return EmployeeListView(viewModel: employeeViewModel)
}

// MARK: - EmployeeList
// EmployeeList: A subview of EmployeeListView that displays the actual list of employees.
// It groups employees by their position and allows users to refresh the list.
struct EmployeeList: View {
    @ObservedObject var viewModel: EmployeeListViewModel
    @State private var selectedEmployee: Employee?
    
    var body: some View {
        ZStack {
            List {
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .listRowBackground(Color.clear)
                        .frame(maxWidth: .infinity)
                }
                ForEach(viewModel.groupedEmployees.keys.sorted(by: <), id: \.self) { position in
                    Section {
                        ForEach(viewModel.groupedEmployees[position] ?? []) { employee in
                            Button(action: {
                                selectedEmployee = employee
                            }) {
                                EmployeeRowView(employee: employee)
                                    .ignoresSafeArea(.all)
                            }
                            .buttonStyle(.plain)
                        }
                    } header: {
                        Text(position.uppercased())
                    }
                    .listRowBackground(Color.offsetBlack)
                    .ignoresSafeArea(.all)
                }
                .padding(.vertical, -3)
            }
            .listStyle(.plain)
            .foregroundStyle(.white)
            .refreshable {
                await viewModel.refresh()
            }
            .sheet(item: $selectedEmployee) { employee in
                EmployeeDetailView(employee: employee)
            }
            
            if viewModel.showErrorAlert {
                ToastErrorMessageView(errorMessage: "An error occurred", onRefresh: {
                    await viewModel.refresh()
                })
            }
        }
    }
}

// MARK: - EmployeeRowView
// EmployeeRowView: A reusable view for displaying a single employee's information in a row.
struct EmployeeRowView: View {
    let employee: Employee
    
    var body: some View {
        ZStack(alignment: .leading) {
            Color.greyBlack
                .cornerRadius(4)
            
            Text("\(employee.fname) \(employee.lname)")
                .font(.body)
                .foregroundColor(.white)
                .frame(height: 72)
                .padding(.leading, 16)
        }
    }
}

// MARK: - CustomHeaderView
// CustomHeaderView: A view at the top of EmployeeListView that contains a logo and a search bar.
struct CustomHeaderView: View {
    @Binding var searchText: String
    
    var body: some View {
        ZStack {
            Color.greyBlack
            
            VStack {
                HStack {
                    Image("Mooncascade")
                        .resizable()
                        .frame(width: 82.5, height: 24)
                        .scaledToFit()
                        .padding(.leading, 16)
                    
                    Spacer()
                    
                    Text("Employees")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    
                    ForEach(0 ..< 3) { item in
                        Spacer()
                    }
                }
                
                SearchBar(text: $searchText)
                    .padding([.leading, .trailing], 12)
            }
        }
    }
}

// MARK: - SearchBar
// SearchBar: A custom search bar view that allows users to filter the list of employees by name, project, or position.
struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        TextField("", text: $text, prompt: Text("searchfield_placeholder").foregroundColor(.white))
            .padding(8)
            .padding(.horizontal, 25)
            .background(Color.grey1)
            .cornerRadius(8)
            .foregroundStyle(.white)
            .overlay(
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.white)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 8)
                    
                    if !text.isEmpty {
                        Button(action: {
                            self.text = ""
                        }) {
                            Image(systemName: "multiply.circle.fill")
                                .foregroundColor(.white)
                                .padding(.trailing, 8)
                        }
                    }
                }
            )
    }
}

// MARK: - ToastErrorMessageView
// ToastErrorMessageView: A view that displays an error message with a refresh button.
// It appears at the bottom of the screen and can be dismissed or used to trigger a refresh of the employee list.
struct ToastErrorMessageView: View {
    var errorMessage: String
    var onRefresh: () async -> Void
    @State private var isPresented = false
    
    var body: some View {
        VStack {
            Spacer()
            
            if isPresented {
                ZStack(alignment: .topTrailing) {
                    HStack {
                        Rectangle().fill(.yellow).frame(width: 8, height: 80)
                        
                        Button(action: {
                            Task {
                                await onRefresh() // Execute the async operation in a new Task
                            }
                        }) {
                            Image(systemName: "arrow.clockwise")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.white)
                                .frame(width: 14, height: 14)
                                .padding(4)
                                .background(.yellow)
                                .clipShape(Circle())
                                .shadow(radius: 3)
                        }
                        
                        Text(errorMessage)
                            .foregroundStyle(.white)
                            .font(.headline)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(height: 88)
                    .background(Color.offsetBlack)
                    .cornerRadius(5)
                    .shadow(radius: 10)
                    .padding(.horizontal)
                    .transition(.move(edge: .bottom))
                    
                    Button(action: {
                        self.isPresented = false
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                            .padding(10)
                            .clipShape(Circle())
                    }
                    .padding(.top, 8)
                    .padding(.trailing, 8)
                }
            }
        }
        .ignoresSafeArea(.all)
        .onAppear {
            withAnimation {
                isPresented = true
            }
            Task {
                try await Task.sleep(nanoseconds: 3_000_000_000)
                withAnimation {
                    isPresented = false
                }
            }
        }
    }
}
