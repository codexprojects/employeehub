//
//  SplashView.swift
//  EmployeeHub
//
//  Created by Ilke Yucel on 12.07.2024.
//

import SwiftUI

struct SplashView: View {
    
    @State var isActive: Bool = false
    
    var body: some View {
        ZStack {
            Color.offsetBlack
                .ignoresSafeArea(.all)
            
            if self.isActive {
                let networkManager = NetworkManager()
                let employeeService = EmployeeService(networkRequest: networkManager)
                let employeeViewModel = EmployeeListViewModel(employeeService: employeeService)
                EmployeeListView(viewModel: employeeViewModel)
                    .tint(Color.offsetBlack)
            } else {
                Image("Mooncascade")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 220, height: 64)
            }
        }
        .onAppear {
            Task {
                try await Task.sleep(nanoseconds: 2_000_000_000)
                await MainActor.run {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}

#Preview {
    SplashView()
}
