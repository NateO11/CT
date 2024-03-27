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
                    
                    SchoolDisclosures(info: viewModel.infoAcademic, title: "Academics").environmentObject(authState)
                    SchoolDisclosures(info: viewModel.infoSocial, title: "Social").environmentObject(authState)
                    SchoolDisclosures(info: viewModel.infoOther, title: "Other").environmentObject(authState)

                    
                    
                }.padding(20)
            }
            .onAppear {
                viewModel.fetchLocations()
                viewModel.fetchInfo()
                viewModel.fetchInfoAcademic()
                viewModel.fetchInfoOther()
                viewModel.fetchInfoSocial()
            }
            .ignoresSafeArea()

        
            //.navigationBarTitle(viewModel.college.name)
        .navigationBarHidden(false)
        .navigationBarBackButtonHidden(false)
    }
}


struct SchoolDisclosures: View {
    @EnvironmentObject var authState: AuthViewModel
    var info: [SchoolInfo]
    var title: String
   
    var body: some View {
        HStack{
            Text(title)
                .font(.title)
                .fontWeight(.heavy)
        }
        VStack {
            ForEach(info, id: \.category) { item in
                DisclosureGroup {
                    HStack(spacing: 30) {
                        ForEach(Array(zip(item.stats, item.statDescriptions)), id: \.0) { statComponent in
                            VStack {
                                Text("\(statComponent.0)").font(.title).bold()
                                Text("\(statComponent.1)").font(.callout).bold()
                            }
                        }
                    }.padding(.bottom, 20)
                    
                    Text(item.description)
                    
                    NavigationLink(destination: EditProfileView().environmentObject(authState)) {
                        VStack(alignment: .center) {
                            Text("Read reviews")
                                .foregroundColor(.white)
                                .bold()
                                .fontWeight(.heavy)
                        }
                    }
                    .frame(width: 160, height: 40)
                    .background(Color.black)
                    .cornerRadius(40)
                    .padding()
                    
                } label: {
                    HStack {
                        Text(item.category).font(.headline)
                        Spacer()
                    }
                }.tint(.black).padding()
            }.background(.black.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        }.padding(.bottom, 20)
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
