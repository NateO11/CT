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
    @State var starred = false

    var body: some View {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    Spacer().frame(height: 70)
                    
                    
                    Image(viewModel.college.image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 350, height: 200)
                            .cornerRadius(8)
                            .shadow(radius: 10)
                    
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
                    
                    LocationScrollView(college: viewModel.college, topLocations: viewModel.featuredLocations)
                    
                    // Navigation Buttons
                    HStack {
                        Spacer()
                        StyledButtonDark(icon: "mappin", title: "View Full Map", destination: MapView(viewModel: MapViewModel(college: viewModel.college)).environmentObject(authState))
                        Spacer()
                    }
                    .padding(.bottom, 10)
                    
                    SchoolDisclosures(info: viewModel.infoAcademic, title: "Academics", college: viewModel.college).environmentObject(authState)
                    SchoolDisclosures(info: viewModel.infoSocial, title: "Social", college: viewModel.college).environmentObject(authState)
                    SchoolDisclosures(info: viewModel.infoOther, title: "Other", college: viewModel.college).environmentObject(authState)

                    
                    
                }.padding(20)
            }
            .onAppear {
                viewModel.fetchLocations()
                

                starred = authState.currentUser?.favorites.contains(viewModel.college.name) ?? false
                    
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
    var college: College
   
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
                    
                    Text(item.description).padding(.bottom, 20)
                    
                    if item.locations.isEmpty == false {
                        VStack {
                            Text("Must See Spots:").font(.callout).bold()
                            ForEach(item.locations, id: \.self) { location in
                                Text("- \(location)")
                            }
                        }
                    }
                    
                    NavigationLink(destination: ForumView(viewModel: ForumViewModel(college: college, info: item, authState: authState))) {
                        VStack(alignment: .center) {
                            Text("Read reviews")
                                .foregroundColor(Color("UniversalBG"))
                                .bold()
                                .fontWeight(.heavy)
                        }
                    }
                    .frame(width: 160, height: 40)
                    .background(Color("UniversalFG"))
                    .cornerRadius(40)
                    .padding()
                    
                } label: {
                    HStack {
                        Text(item.category).font(.headline)
                        Spacer()
                    }
                }.tint(Color("UniversalFG")).padding()
            }.background(Color("UniversalFG").opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        }.padding(.bottom, 20)
    }
}



