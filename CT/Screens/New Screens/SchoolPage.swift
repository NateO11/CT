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
    @EnvironmentObject var authState: AuthViewModel
    @ObservedObject var viewModel: MapViewModel

    var body: some View {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    Spacer().frame(height: 70)
                    
                    HStack {
                        Spacer()
                        Image(viewModel.college.image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 300, height: 200)
                            .cornerRadius(8)
                            .shadow(radius: 10)
                        Spacer()
                    }
                    
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
                    
                    
                    Text("More info")
                        .font(.title)
                        .fontWeight(.heavy)
                    
                    SchoolDisclosures(info: viewModel.info)
                    
                    
                }.padding(20)
            }
            .onAppear {
                viewModel.fetchLocations()
                viewModel.fetchInfo()
            }
            .ignoresSafeArea()

        
            //.navigationBarTitle(viewModel.college.name)
        .navigationBarHidden(false)
        .navigationBarBackButtonHidden(false)
    }
}


struct SchoolDisclosures: View {
    var info: [SchoolInfo]
    var body: some View {
        VStack {
            ForEach(info, id: \.category) { info in
                DisclosureGroup {
                    Text(info.description)
                } label: {
                    HStack {
                        Text(info.category).font(.headline)
                        Spacer()
                    }
                }.tint(.black).padding()
            }.background(.black.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
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
