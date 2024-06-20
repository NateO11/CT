//
//  NewSchoolView.swift
//  CT
//
//  Created by Griffin Harrison on 6/5/24.
//

import Foundation
import SwiftUI
import MapKit
import Firebase


struct TopicImagePair {
    var topic: String
    var url: String
}


var basicImagePairs: [TopicImagePair] =  [TopicImagePair(topic: "Charlottesville", url: "https://charlottesville.guide/wp-content/uploads/2019/02/trin1-1.jpg"),
    TopicImagePair(topic: "Athletics", url: "https://news.virginia.edu/sites/default/files/article_image/mens_hoops_academics_mr_header_1.jpg"),
    TopicImagePair(topic: "Dorms", url: "https://news.virginia.edu/sites/default/files/Header_New_Dorms_Aerial__SS_01-2.jpg"),
    TopicImagePair(topic: "Recreation", url: "https://rec.virginia.edu/sites/recsports2017.virginia.edu/files/indoor-pool-at-ngrc-uva.jpg"),
    TopicImagePair(topic: "Academics", url: "https://news.virginia.edu/sites/default/files/article_image/thornton_hall_engineering_fall_ss_header_3-2.jpg"),
    TopicImagePair(topic: "Dining", url: "https://wcav.images.worldnow.com/images/20205423_G.jpg?auto=webp&disable=upscale&height=560&fit=bounds&lastEditedDate=1609193636000"),
                                          
                                          
]



let categories = ["Landmark", "Athletics", "Dining", "Dorms", "Library", "School Building"]

// potential animation when school viewed for the first time

struct NewSchoolView: View {
    @EnvironmentObject var authState: AuthViewModel
    @ObservedObject var viewModel: MapViewModel
    var gridItemLayout: [GridItem] = [GridItem(), GridItem()]

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [.clear.opacity(0.5), .clear, .clear, ], startPoint: .topTrailing, endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)
                LinearGradient(colors: [.clear, .clear, .clear, .clear, .clear, ], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(alignment: .leading) {
                        Text(viewModel.college.name)
                            .font(.largeTitle).padding(.horizontal, 18).fontWeight(.bold).padding(.top, 10)
                        Text(viewModel.college.city).font(.headline).fontWeight(.light)
                            .padding(.horizontal, 18)
                        LazyVGrid(columns: gridItemLayout, alignment: .center, spacing: 15) {
                            NavigationLink(destination: SchoolTopicPage(viewModel: MapViewModel(college: viewModel.college), topic: "Landmark")) {
                                SchoolTopicCard(topic: "Basics", imageURL: topicToURL(topic: "Basics"))
                            }
                            NavigationLink(destination: MapView(viewModel: MapViewModel(college: viewModel.college)).environmentObject(authState)) {
                                SchoolTopicCard(topic: "Map", imageURL: topicToURL(topic: "Map"))
                            }
                            ForEach(categories, id: \.self) { topic in
                                NavigationLink(destination: SchoolTopicPage(viewModel: MapViewModel(college: viewModel.college), topic: topic)) {
                                    SchoolTopicCard(topic: topic, imageURL: topicToURL(topic: topic))
                                }
                                
                            }
                            
                        }.padding(.horizontal, 20)
                            .padding(.top, 15)
                    }
                    
                    
                }
                .scrollIndicators(.hidden)
                

                
                
                
            }
        }
        
        
    }
    
    func topicToURL(topic: String) -> String {
        if topic == "Landmarks" {
            return "https://charlottesville.guide/wp-content/uploads/2019/02/trin1-1.jpg"
        } else if topic == "Dorms" {
            return "https://news.virginia.edu/sites/default/files/Header_New_Dorms_Aerial__SS_01-2.jpg"
        } else if topic == "Dining" {
            return "https://wcav.images.worldnow.com/images/20205423_G.jpg?auto=webp&disable=upscale&height=560&fit=bounds&lastEditedDate=1609193636000"
        } else if topic == "Athletics" {
            return "https://news.virginia.edu/sites/default/files/article_image/mens_hoops_academics_mr_header_1.jpg"
        } else if topic == "School Building" {
            return "https://news.virginia.edu/sites/default/files/article_image/thornton_hall_engineering_fall_ss_header_3-2.jpg"
        } else if topic == "Library" {
            return "https://news.virginia.edu/sites/default/files/Header_SF_AldermanRenaming_TomDaly.jpg"
        } else if topic == "Basics" {
            return "https://i.pinimg.com/originals/1d/13/12/1d13123d3570cc0d571ad118dda87460.jpg"
        } else if topic == "Map" {
            return "https://rotunda.virginia.edu/sites/g/files/jsddwu951/files/styles/crop_freeform/public/2022-01/Lawn_Aerial_Spring_2020_SS_05%20%281%29.jpg?itok=tnokOEHp"
        } else {
            return "https://charlottesville.guide/wp-content/uploads/2019/02/trin1-1.jpg"
        }
    }
}





struct SchoolTopicCard: View {
    var topic: String
    var imageURL: String
    
    var body: some View {
        AsyncImage(url: URL(string: imageURL)) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 160, height: 150)
                .overlay {
                    
                    LinearGradient(colors: [
                        Color.clear,
                        .clear,
                        .clear,
                        .clear,
                        .black.opacity(0.3),
                        .black.opacity(0.6),
                        .black.opacity(0.8)
                    ], startPoint: .top, endPoint: .bottom)
                    
                    VStack(alignment: .leading, spacing: 4, content: {
                        
                        Spacer()
                        HStack(alignment: .bottom) {
                            VStack(alignment: .leading) {
                                Text(topic)
                                    .font(.callout)
                                    .multilineTextAlignment(.leading)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.white)
                                
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.callout)
                                .bold()
                                .foregroundColor(.white)
                            
                        }
                        
                    })
                    .padding(.vertical, 20)
                    .padding(.leading, 15)
                    .padding(.trailing, 10)

                    
                }
                .clipShape(.rect(cornerRadius: 15))
                .shadow(color: .black.opacity(0.4), radius: 5, x: 5, y: 10)
        } placeholder: {
            Color.black
                .frame(width: 160, height: 150)
                .clipShape(.rect(cornerRadius: 15))
                .shadow(color: .black.opacity(0.4), radius: 5, x: 5, y: 10)
        }
    }
}


struct SchoolTopicPage: View {
    @EnvironmentObject var authState: AuthViewModel
    @ObservedObject var viewModel: MapViewModel
    var topic: String
    var body: some View {
        
        ZStack {
            LinearGradient(colors: [.clear.opacity(0.5), .clear, .clear, ], startPoint: .topTrailing, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            LinearGradient(colors: [.clear, .clear, .clear, .clear, .clear, ], startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                HStack {
                    VStack(alignment: .leading) {
                        Text(topic)
                            .font(.largeTitle).padding(.horizontal, 18).fontWeight(.bold).padding(.top, 10)
                        Text(viewModel.college.name).font(.headline).fontWeight(.light)
                            .padding(.horizontal, 18)
                    }
                    Spacer()
                }
                VStack {
                    NewLocationScrollView(college: viewModel.college, topicLocations: viewModel.locations.filter { $0.category == topic })
                    
                    GroupBox {
                        Text("UVA is home to 27 D1 NCAA sports teams and competes in the ACC conference. The Hoos have brought home 35 championship trophies over the past decade - the most famous being the mens March Madness victory in 2019.")
                    }.padding(.horizontal, 20)
                }
                
            }
            .scrollIndicators(.hidden)
            
        }
        .onAppear {
            viewModel.fetchLocations()
        }
    }
    
}


struct Stat {
    var value: Int
    var label: String
    var suffix: String?
}

var BasicStats: [Stat] = [Stat(value: 17, label: "Students", suffix: "k"), Stat(value: 95, label: "Graduation", suffix: "%"), Stat(value: 26, label: "Acceptance", suffix: " %")]




struct NewLocationScrollView: View {
    @EnvironmentObject var authState: AuthViewModel
    var college: College
    var topicLocations: [Location]
    var body: some View {
        GeometryReader(content: { geometry in
            let size = geometry.size
            
            ScrollView(.horizontal) {
                HStack(spacing: 4) {
                    ForEach(topicLocations) { location in
                        NavigationLink(destination: MapView(viewModel: MapViewModel(college: college), initialSelectedLocation: location).environmentObject(authState)) {
                            GeometryReader(content: { proxy in
                                let cardSize = proxy.size
                                let minX = proxy.frame(in: .scrollView).minX - 60
                                // let minX = min(((proxy.frame(in: .scrollView).minX - 60) * 1.4), size.width * 1.4)
                                    
                                if location.imageLink == "" {
                                    Image(college.image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .offset(x: -minX)
                                        .frame(width: proxy.size.width * 1.5)
                                        .frame(width: cardSize.width, height: cardSize.height)
                                        .overlay {
                                            OverlayView(college, location)
                                        }
                                        .clipShape(.rect(cornerRadius: 15))
                                        .shadow(color: .black.opacity(0.25), radius: 8, x: 5, y: 10)
                                } else {
                                    AsyncImage(url: URL(string: location.imageLink)) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                    } placeholder: {
                                        Color.gray
                                    }
                                    .offset(x: -minX)
                                    .frame(width: proxy.size.width * 2)
                                    .frame(width: cardSize.width, height: cardSize.height)
                                    .overlay {
                                        OverlayView(college, location)
                                    }
                                    .clipShape(.rect(cornerRadius: 15))
                                    .shadow(color: .black.opacity(0.25), radius: 8, x: 5, y: 10)
                                }
                                
                                
                            })
                            .frame(width: size.width - 120, height: size.height - 30)
                            .scrollTransition(.interactive, axis: .horizontal) {
                                view, phase in
                                view
                                    .scaleEffect(phase.isIdentity ? 1 : 0.95)
                        }
                        }
                   
                    }
                }
                .padding(.horizontal, 60)
                .scrollTargetLayout()
                .frame(height: size.height, alignment: .top)
                
            }
            .scrollTargetBehavior(.viewAligned)
            .scrollIndicators(.hidden)
        })
        .frame(height: 250)
        .padding(.horizontal, -15)
        .padding(.top, 10)
            
        
    }
    @ViewBuilder
    func OverlayView(_ college: College, _ location: Location) -> some View {

        ZStack(alignment: .bottomLeading, content: {
            LinearGradient(colors: [
                Color.clear,
                .clear,
                .clear,
                .black.opacity(0.1),
                .black.opacity(0.5),
                .black
            ], startPoint: .top, endPoint: .bottom)
            
            VStack(alignment: .leading, spacing: 4, content: {
                Spacer()
                HStack(alignment: .bottom ) {
                    VStack(alignment: .leading) {
                        Text(location.name)
                            .font(.title2)
                            .multilineTextAlignment(.leading)
                            .fontWeight(.black)
                            .foregroundStyle(.white)
                        Text(location.category)
                            .font(.callout)
                            .foregroundStyle(.white.opacity(0.8))
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                        .padding(.bottom, 10)
                }
                
            })
            .padding(20)
        })
        
    }
}


var UVA: College = .init(id: "UVA", available: true, name: "University of Virginia", city: "Charlottesville, Virginia", description: "A lovely school", image: "UVA", coordinate: CLLocationCoordinate2D(latitude: 38, longitude: -77.1), color: Color.orange)





