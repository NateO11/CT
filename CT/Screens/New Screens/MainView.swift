//
//  MainView.swift
//  CT
//
//  Created by Nate Owen on 1/16/24.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            // Tab 1
            ExploreView(viewModel: ExploreViewModel(), ID: "placeholder")
                .tabItem {
                    Image(systemName: "house")
                    Text("Tab 1")
                }

            // Tab 2
            ExploreView(viewModel: ExploreViewModel(), ID: "placeholder")
                .tabItem {
                    Image(systemName: "1.circle")
                    Text("Tab 1")
                }

        }
    }
}


#Preview {
    MainView()
}
