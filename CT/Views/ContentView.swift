//
//  ContentView.swift
//  CT
//
//  Created by Nate Owen on 3/7/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var isLoading = true

    var body: some View {
        Group {
            if isLoading {
                ProgressView("Getting paper...")
                    .onAppear {
                        Task {
                            await viewModel.fetchUser()
                            isLoading = false
                        }
                    }
            } else if viewModel.currentUser != nil {
                ExploreView(viewModel: ExploreViewModel()).environmentObject(viewModel)
            } else {
                SignUpView()
            }
        }
    }
}

