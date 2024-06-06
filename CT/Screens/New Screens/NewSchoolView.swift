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


var basicImagePairs: [TopicImagePair] =  [TopicImagePair(topic: "Athletics", url: "https://news.virginia.edu/sites/default/files/article_image/mens_hoops_academics_mr_header_1.jpg"),
                                          TopicImagePair(topic: "Dorms", url: "https://i0.wp.com/bcc-newspack.s3.amazonaws.com/uploads/2021/05/050321-Parkway-Gardens-ColinBoyle-14.jpg?fit=1200%2C798&ssl=1"),
                                          TopicImagePair(topic: "Local area", url: "https://charlottesville.guide/wp-content/uploads/2019/02/trin1-1.jpg"),
                                          TopicImagePair(topic: "Recreation", url: "https://rec.virginia.edu/sites/recsports2017.virginia.edu/files/indoor-pool-at-ngrc-uva.jpg"),
                                          TopicImagePair(topic: "Engineering", url: "https://news.virginia.edu/sites/default/files/article_image/thornton_hall_engineering_fall_ss_header_3-2.jpg"),
                                          TopicImagePair(topic: "Dining", url: "https://lh3.googleusercontent.com/mw7ZoK3R4VQNRqI2unzf-XacniB9VRCyWmDfz23amzKRshxAznFr6EYHj0aD0WOO0V0b5b9SGdhFfXrPHZqD48i9t1OG0ij_SBUl-Xg"),
                                          TopicImagePair(topic: "Hiking", url: "https://thehoppyhikers.com/wp-content/uploads/2021/11/rivanna001.jpeg"),
                                          TopicImagePair(topic: "Dorm s", url: "https://i0.wp.com/bcc-newspack.s3.amazonaws.com/uploads/2021/05/050321-Parkway-Gardens-ColinBoyle-14.jpg?fit=1200%2C798&ssl=1"),
                                          TopicImagePair(topic: "Trin 1", url: "https://charlottesville.guide/wp-content/uploads/2019/02/trin1-1.jpg"),
]


// potential animation when school viewed for the first time

struct NewSchoolView: View {
    @EnvironmentObject var authState: AuthViewModel
    @ObservedObject var viewModel: MapViewModel
    @State var starred = false
    
    var gridItemLayout: [GridItem] = [GridItem(), GridItem()]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text(viewModel.college.name)
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                
                Text(viewModel.college.city)
                    .font(.title3)
                    .foregroundColor(.secondary)
                
                LazyVGrid(columns: gridItemLayout, alignment: .center, spacing: 15) {
                    SchoolTopicView(topic: "Basics", imageURL: "https://reveal.scholarslab.org/images/trigger_images/Rotunda_above.jpg")
                    SchoolTopicView(topic: "Map", imageURL: "https://media.wired.com/photos/59269cd37034dc5f91bec0f1/master/pass/GoogleMapTA.jpg")
                    ForEach(basicImagePairs, id: \.topic) { item in
                        NavigationLink(destination: EditProfileView()) {
                            SchoolTopicView(topic: item.topic, imageURL: item.url)
                        }
                        
                    }
                }
            }.padding(.horizontal, 20)
            
        }
        .scrollIndicators(.hidden)
    }
}





struct SchoolTopicView: View {
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
                        .black.opacity(0.5),
                        .black.opacity(0.8),
                        .black
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
                    .padding(.horizontal, 15)

                    
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
