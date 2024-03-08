//
//  ContentView.swift
//  CT
//
//  Created by Nate Owen on 3/7/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        Group {
            if viewModel.userSession != nil {
                ProfilePage()
            }
            else{
                LoginPageView()
            }
        }
    }
}

//#Preview {
//    ContentView()
//}
