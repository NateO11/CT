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


// potential animation when school viewed for the first time

struct NewSchoolView: View {
    // @EnvironmentObject var authState: AuthViewModel
    // @ObservedObject var viewModel: MapViewModel
    var college: College
    var gridItemLayout: [GridItem] = [GridItem(), GridItem()]

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [.pink.opacity(0.5), .clear, .clear, .clear, .clear, ], startPoint: .topTrailing, endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)
                LinearGradient(colors: [.orange, .clear, .clear, .clear, .clear, ], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(alignment: .leading) {
                        Text(college.name)
                            .font(.largeTitle).padding(.horizontal, 18).fontWeight(.bold).padding(.top, 10)
                        Text(college.city).font(.headline).fontWeight(.light)
                            .padding(.horizontal, 18)
                        LazyVGrid(columns: gridItemLayout, alignment: .center, spacing: 15) {
                            SchoolTopicCard(topic: "Basics", imageURL: "https://reveal.scholarslab.org/images/trigger_images/Rotunda_above.jpg")
                            SchoolTopicCard(topic: "Map", imageURL: "https://www.mapshop.com/wp-content/uploads/2017/10/uva_1.jpg")
                            ForEach(basicImagePairs, id: \.topic) { item in
                                NavigationLink(destination: SchoolTopicPage(college: college, topic: item.topic)) {
                                    SchoolTopicCard(topic: item.topic, imageURL: item.url)
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
    // @EnvironmentObject var authState: AuthViewModel
    // @ObservedObject var viewModel: MapViewModel
    var college: College
    var topic: String
    var body: some View {
        ScrollView {
            VStack {
                NewLocationScrollView(college: college, topicLocations: sampleLocations)
                GroupBox {
                }.groupBoxStyle(StatsGroupBoxStyle(topic: topic, stats: BasicStats))
                    .padding(.horizontal, 10)
                GroupBox {
                    Text("The description of the topic will go here. The description of the topic will go here. The description of the topic will go here. The description of the topic will go here. ")
                }.padding(.horizontal, 10)
            }
            
        }
        .scrollIndicators(.hidden)
        .navigationTitle(college.id)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text(topic).font(.headline)
                    Text(college.name).font(.subheadline)
                }.padding()
            }
            ToolbarItem(placement: .topBarTrailing) {
                Image(systemName: "ellipsis.circle")
                    .font(.title2)
                    .foregroundColor(Color("UniversalFG"))
            }
        }
    }
    
}


struct Stat {
    var value: Int
    var label: String
    var suffix: String?
}

var BasicStats: [Stat] = [Stat(value: 1600, label: "SAT"), Stat(value: 57, label: "Majors"), Stat(value: 26, label: "Acceptance", suffix: " %")]

struct StatsGroupBoxStyle: GroupBoxStyle {
    var topic: String
    var stats: [Stat]
    func makeBody(configuration: Configuration) -> some View {
        GroupBox(label: Label("By the numbers", systemImage: "chart.pie.fill").foregroundStyle(.blue), content: {
            HStack {
                ForEach(stats, id: \.label) { stat in
                    HStack {
                        VStack(alignment: .leading) {
                            
                            Text(String(stat.value)).font(.system(size: 24, weight: .bold, design: .rounded)) + Text(stat.suffix ?? "").font(.system(size: 14, weight: .semibold, design: .rounded))
                            Text(stat.label).font(.system(size: 16, weight: .semibold, design: .rounded)).lineLimit(2)
                            
                        }.padding(.horizontal)
                        if stats.last?.label != stat.label  {
                            Divider()
                                .frame(width: 1)
                                .overlay(.black)
                        }
                    }
                }
                Spacer()
            }
        })
    }
    
    
}


struct NewLocationScrollView: View {
    // @EnvironmentObject var authState: AuthViewModel
    var college: College
    var topicLocations: [Location]
    var body: some View {
        GeometryReader(content: { geometry in
            let size = geometry.size
            
            ScrollView(.horizontal) {
                HStack(spacing: 4) {
                    ForEach(topicLocations) { location in
                        NavigationLink(destination: EditProfileView()) {
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




#Preview(body: {
    NewSchoolView(college: UVA)
})
