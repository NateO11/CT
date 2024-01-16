//
//  TabView.swift
//  CT
//
//  Created by Nate Owen on 1/16/24.
//

import SwiftUI

struct TabView: View {
    var body: some View {
        TabView {
            // Tab 1
            Text("First Tab")
                .tabItem {
                    Image(systemName: "1.circle")
                    Text("Tab 1")
                }
            
            // Tab 2
            Text("Second Tab")
                .tabItem {
                    Image(systemName: "2.circle")
                    Text("Tab 2")
                }
            
            // Add more tabs as needed
        }
    }
}

#Preview {
    TabView()
}
