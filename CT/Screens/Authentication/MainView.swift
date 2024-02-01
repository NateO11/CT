//
//  MainView.swift
//  CT
//
//  Created by Nate Owen on 1/19/24.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView{
            ExploreView(viewModel: ExploreViewModel(), ID: "4xLrvkubquPQIVNSrUrGCW1Twhi2")
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Explore")
                }
            
            SearchView(colleges: sampleColleges)
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
            
            ProfilePage(userID: "4xLrvkubquPQIVNSrUrGCW1Twhi2")
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
