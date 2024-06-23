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
                    let city = viewModel.college.city.components(separatedBy: ",")[0]
                    let categories = [city, "Athletics", "Recreation", "Dining", "Dorms", "Academics"]
                    VStack(alignment: .leading) {
                        Text(viewModel.college.name)
                            .font(.largeTitle).padding(.horizontal, 18).fontWeight(.bold).padding(.top, 10)
                        Text(viewModel.college.city).font(.headline).fontWeight(.light)
                            .padding(.horizontal, 18)
                        LazyVGrid(columns: gridItemLayout, alignment: .center, spacing: 15) {
                            NavigationLink(destination: SchoolTopicPage(viewModel: MapViewModel(college: viewModel.college), topicViewModel: TopicViewModel(topic: "Basics", college: viewModel.college))) {
                                SchoolTopicCard(topic: "Basics", imageURL: topicToURL(topic: "Basics"))
                            }
                            NavigationLink(destination: MapView(viewModel: MapViewModel(college: viewModel.college)).environmentObject(authState)) {
                                SchoolTopicCard(topic: "Map", imageURL: topicToURL(topic: "Map"))
                            }
                            ForEach(categories, id: \.self) { topic in
                                NavigationLink(destination: SchoolTopicPage(viewModel: MapViewModel(college: viewModel.college), topicViewModel: TopicViewModel(topic: topic, college: viewModel.college))) {
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
        if topic == "Charlottesville" {
            return "https://charlottesville.guide/wp-content/uploads/2019/02/trin1-1.jpg"
        } else if topic == "Dorms" {
            return "https://news.virginia.edu/sites/default/files/Header_New_Dorms_Aerial__SS_01-2.jpg"
        } else if topic == "Dining" {
            return "https://wcav.images.worldnow.com/images/20205423_G.jpg?auto=webp&disable=upscale&height=560&fit=bounds&lastEditedDate=1609193636000"
        } else if topic == "Athletics" {
            return "https://news.virginia.edu/sites/default/files/article_image/mens_hoops_academics_mr_header_1.jpg"
        } else if topic == "Academics" {
            return "https://news.virginia.edu/sites/default/files/article_image/thornton_hall_engineering_fall_ss_header_3-2.jpg"
        } else if topic == "Recreation" {
            return "https://rec.virginia.edu/sites/recsports2017.virginia.edu/files/styles/hero_image/public/indoor-lap-pool-at-ngrc-uva_0.jpg?itok=9MnguXas"
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
    @ObservedObject var topicViewModel: TopicViewModel
    var body: some View {
        
        ZStack {
            LinearGradient(colors: [.clear.opacity(0.5), .clear, .clear, ], startPoint: .topTrailing, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            LinearGradient(colors: [.clear, .clear, .clear, .clear, .clear, ], startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                HStack {
                    VStack(alignment: .leading) {
                        Text(topicViewModel.topic)
                            .font(.largeTitle).padding(.horizontal, 18).fontWeight(.bold).padding(.top, 10)
                        Text(viewModel.college.name).font(.headline).fontWeight(.light)
                            .padding(.horizontal, 18)
                    }
                    Spacer()
                }
                VStack {
                    NewLocationScrollView(college: viewModel.college, topicLocations: viewModel.locations.filter { $0.category == topicViewModel.topic })
                    
                    InformationCardView(stats: topicViewModel.stats, bodyText: topicViewModel.bodyText)
                        .padding(.horizontal, 20)
                    
                    ReviewsCardView(viewModel: TopicViewModel(topic: topicViewModel.topic, college: viewModel.college, authState: authState), reviews: topicViewModel.reviews).environmentObject(authState)
                        .padding(.horizontal, 20)
                }
                
            }
            .scrollIndicators(.hidden)
            
        }
        .onAppear {
            viewModel.fetchLocations()
            topicViewModel.fetchReviews()
            topicViewModel.fetchTopicData()
        }
    }
    
}


var BasicStats: [Stat] = [Stat(symbolName: "graduationcap.fill", color: 15036928, intValue: 98, statDescription: "Graduation rate", intSuffix: "%"), Stat(symbolName: "person.fill", color: 15036928, intValue: 20, statDescription: "Student population", intSuffix: "k")]
var sampleBodyText: String = "UVA is an incredible institution that lies in the beautiful city of Charlottesville, Virginia. I don't really know what else to say, but I'm sure I will come up with it at some point. For now I just want enough text to make it seem like I filled the space"


struct InformationCardView: View {
    var stats: [Stat]
    var bodyText: String
    var body: some View {
        GroupBox {
            if stats.isEmpty {
                Text("School info coming soon")
                    .font(.title2)
                    .padding()
                    .frame(maxWidth: .infinity)
            } else {
                VStack {
                    ForEach(stats, id: \.statDescription) { stat in
                        HStack(spacing: 0) {
                            ZStack {
                                Circle()
                                    .fill(Color(hex: stat.color).opacity(0.7).gradient)
                                    .frame(width: 45, height: 45)
                                Image(systemName: stat.symbolName)
                                    .foregroundStyle(.white)
                                    .font(.title2)
                            }
                            .padding(.trailing, 5)
                            VStack(alignment: .leading, spacing: 0) {
                                HStack(spacing: 0) {
                                    Text(String(stat.intValue))
                                        .font(.title3)
                                        .fontWeight(.semibold)
                                    Text(stat.intSuffix)
                                        .font(.title3)
                                    
                                }
                                Text(stat.statDescription)
                                    .font(.subheadline)
                                    .fontWeight(.light)
                                    .foregroundStyle(.primary.opacity(0.8))
                                
                            }
                            .padding(.leading, 5)
                            Spacer()
                        }
                    }
                    .padding(.bottom, 5)
                    Text(bodyText)
                        .font(.subheadline)
                }
            }
        }.backgroundStyle(Color("UniversalBG").gradient)
            .clipShape(RoundedRectangle(cornerRadius: 25))
    }
}


struct ReviewsCardView: View {
    @EnvironmentObject var authState: AuthViewModel
    @ObservedObject var viewModel: TopicViewModel
    var reviews: [Review]
    @State private var displaySheet: Bool = false

    var body: some View {
        GroupBox {
            VStack {
                HStack {
                    Text("Student Insights")
                        .font(.title2)
                        .bold()
                    Spacer()
                    Button {
                        displaySheet.toggle()
                    } label: {
                        Image(systemName: "plus.bubble")
                            .font(.title2)
                    }
                }
                
                if reviews.isEmpty {
                    Text("Be the first to share your thoughts!")
                        .padding()
                } else {
                    ForEach(reviews, id: \.text) { review in
                        let firstChar = Array(review.userID)[0]
                        IndividualReviewView(review: review, firstChar: String(firstChar).uppercased(), isProfilePage: false, isStars: false)
                        
                    } // uses individual review view for consistent formatting throughout
                    
                }
            }
        }.backgroundStyle(Color("UniversalBG").gradient)
            .clipShape(RoundedRectangle(cornerRadius: 25))
        
        .sheet(isPresented: $displaySheet) {
            NewTopicReviewView(viewModel: TopicViewModel(topic: viewModel.topic, college: viewModel.college, authState: authState), isPresented: $displaySheet) { rating, title, text in
                viewModel.submitReview(rating: rating, title: title, text: text, forLocation: viewModel.topic)
            }
            .presentationDetents([.fraction(0.4)])
        }
        .onAppear {
            viewModel.fetchReviews()
        }
    }
    
}


struct NewTopicReviewView: View {
    @EnvironmentObject var authState: AuthViewModel
    @ObservedObject var viewModel: TopicViewModel
    
    
    @Binding var isPresented: Bool
    @State private var titleText: String = ""
    @State private var reviewText: String = ""
    @State private var showAlert: Bool = false
    var onSubmit: (Int, String, String) -> Void
    
    var body: some View {
        VStack {
            HStack {
                Button("Cancel") {
                    isPresented = false
                }
                Spacer()
                Text("Write a Review")
                    .font(.title3)
                    .bold()
                Spacer()
                Button("Submit") {
                    if titleText != "" && reviewText != ""  {
                        onSubmit(0, titleText, reviewText)
                        Analytics.logEvent("Review", parameters: ["user": authState.currentUser?.fullname ?? "nil","title": titleText,"text": reviewText])
                        viewModel.fetchReviews()
                        isPresented = false
                    } else {
                        showAlert = true
                    }
                }
                    .alert("Must fill out all fields! \nGet a clue lil bro", isPresented: $showAlert, actions: {})
                    .sensoryFeedback(.success, trigger: isPresented)
            }
            
            Rectangle()
                .fill(Color("UniversalFG").opacity(0.3))
                .frame(height: 1)
            TextField("Title your review", text: $titleText)
                .textFieldStyle(.automatic)
                .font(.title2)
            Rectangle()
                .fill(Color("UniversalFG").opacity(0.3))
                .frame(height: 1)
            ZStack(alignment: .leading) {
                if reviewText == "" {
                    VStack {
                        Text("Share your thoughts!")
                            .textFieldStyle(.automatic)
                            .font(.title2)
                            .foregroundStyle(Color("UniversalFG"))
                            .padding(.vertical, 8)
                            .padding(.horizontal, 5)
                        Spacer()
                    }
                    
                }
                TextEditor(text: $reviewText)
                    .textFieldStyle(.automatic)
                    .font(.title2)
                    .opacity(reviewText == "" ? 0.8 : 1)
            }.padding(.leading, -4)
            
            Spacer()
            
        }
        .padding()
    }
}


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





