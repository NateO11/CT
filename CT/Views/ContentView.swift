//
//  ContentView.swift
//  CT
//
//  Created by Nate Owen on 12/10/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
                    ExplorePage()
                        .tabItem {
                            Image(systemName: "house")
                            Text("Explore")
                        }

                    SchoolSelect()
                        .tabItem {
                            Image(systemName: "magnifyingglass")
                            Text("Search")
                        }

                    MapView()
                        .tabItem {
                            Image(systemName: "map")
                            Text("Reviews")
                        }

                    ProfilePage()
                        .tabItem {
                            Image(systemName: "person")
                            Text("Profile")
                        }
                }
            }
        }
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
