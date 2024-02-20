//
//  MainView.swift
//  CT
//
//  Created by Nate Owen on 1/19/24.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var authState: AuthState
    var body: some View {
        TabView{
            ExploreView(viewModel: ExploreViewModel())
                .environmentObject(authState)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Explore")
                }
            
            SearchView(colleges: sampleColleges)
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
            
            ProfilePage()
                .environmentObject(authState)
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    MainView()
}
