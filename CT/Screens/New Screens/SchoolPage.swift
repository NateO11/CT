//
//  SchoolPage.swift
//  CT
//
//  Created by Griffin Harrison on 2/1/24.
//

import Foundation
import SwiftUI
import MapKit
import Firebase

struct SchoolView: View {
    @EnvironmentObject var authState: AuthState
    @ObservedObject var viewModel: MapViewModel

    var body: some View {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    Spacer().frame(height: 70)
                    
                    // School Information
                    Text(viewModel.college.name)
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .padding(.bottom, 10)
                    
                    Text(viewModel.college.city)
                        .font(.title3)
                        .foregroundColor(.secondary)
                        .padding(.bottom, 5)
                    
                    Text(viewModel.college.description)
                        .padding(.bottom, 10)
                    
                    Text("Notable locations")
                        .font(.title)
                        .fontWeight(.heavy)
                    
                    LocationScrollView(college: viewModel.college, topLocations: viewModel.filteredLocations)
                    
                    // Navigation Buttons
                    HStack {
                        Spacer()
                        StyledButtonDark(icon: "mappin", title: "View Full Map", destination: MapView(viewModel: MapViewModel(college: viewModel.college)).environmentObject(authState))
                        Spacer()
                    }
                    .padding(.bottom, 10)
                    
                    
                    Text("Reviews")
                        .font(.title)
                        .fontWeight(.heavy)
                    
                    VStack {
                        HStack {
                            NavigationLink(destination: ForumsTemplate(viewModel: ForumViewModel(college: viewModel.college, forum: "General"))) {
                                RectView(color: Color.blue, title: "General")
                            }.frame(height: 150)
                            NavigationLink(destination: ForumsTemplate(viewModel: ForumViewModel(college: viewModel.college, forum: "Greek Life"))) {
                                RectView(color: Color.orange, title: "Greek \nLife")
                            }.frame(height: 150)
                        }
                        HStack {
                            NavigationLink(destination: ForumsTemplate(viewModel: ForumViewModel(college: viewModel.college, forum: "Athletics"))) {
                                RectView(color: Color.orange, title: "Athletics")
                            }.frame(height: 150)
                            NavigationLink(destination: ForumsTemplate(viewModel: ForumViewModel(college: viewModel.college, forum: "Engineering"))) {
                                RectView(color: Color.blue, title: "Engineering")
                            }.frame(height: 150)
                        }
                    }.padding(.bottom, 40)
                    
                }.padding(20)
            }
            .onAppear {
                viewModel.fetchLocations()
            }
            .ignoresSafeArea()

        
            .navigationBarTitle(viewModel.college.name)
        .navigationBarHidden(false)
        .navigationBarBackButtonHidden(false)
    }
}




struct RectView: View {
    var color: Color
    var title: String
    var body: some View {
        ZStack {
            Rectangle()
                .fill(color)
                .overlay(alignment: .leading) {
                    Circle()
                        .fill(color)
                        .overlay {
                            Circle()
                                .fill(Color.white.opacity(0.3))
                        }
                        .scaleEffect(2, anchor: .topLeading)
                        .offset(x: -150, y: 50)
                }
                .overlay(alignment: .leading) {
                    Circle()
                        .fill(color)
                        .overlay {
                            Circle()
                                .fill(Color.white.opacity(0.2))
                        }
                        .scaleEffect(0.8, anchor: .topLeading)
                        .offset(x: 80, y: -150)
                }
                .overlay(alignment: .leading) {
                    Circle()
                        .fill(color)
                        .overlay {
                            Circle()
                                .fill(Color.white.opacity(0.4))
                        }
                        .scaleEffect(1.2, anchor: .topLeading)
                        .offset(x: 130, y: -50)
                }
                .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
            VStack(alignment: .leading) {
                Spacer()
                Text(title)
                    .font(.title)
                    .foregroundStyle(.white)
            }
        }
    }
}

struct StyledButtonDark<Destination: View>: View {
    let icon: String
    let title: String
    let destination: Destination

    var body: some View {
        NavigationLink(destination: destination) {
            HStack(alignment: .center) {
                Image(systemName: icon)
                    .foregroundColor(.white)
                    .bold()
                Text(title)
                    .foregroundColor(.white)
                    .padding(.leading, 5)
                    .bold()
                    .fontWeight(.heavy)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading)
        }
        .frame(width: 180, height: 60)
        .background(Color.black)
        .cornerRadius(40)
    }
}
