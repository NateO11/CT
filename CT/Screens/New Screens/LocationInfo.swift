//
//  LocationInfo.swift
//  CT
//
//  Created by Griffin Harrison on 2/8/24.
//

import Foundation
import SwiftUI
import MapKit



struct LocationTestingView: View {
    @EnvironmentObject var authState: AuthViewModel
    @ObservedObject var viewModel: LocationViewModel
    @State private var displaySheet: Bool = false
    
    var averageRating: Double {
        guard !viewModel.reviews.isEmpty else {return 0.0}
        let totalRating = viewModel.reviews.reduce(0) {$0 + $1.rating}
        return Double(totalRating) / Double(viewModel.reviews.count)
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(viewModel.location.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .lineLimit(2)
                
                    
                Spacer()
                
            }
            .padding(.leading, 20)
            .padding(.trailing, 100)
            .padding(.top, 20)
            .padding(.bottom, -10)
            ScrollView(showsIndicators: false) {
                LazyVStack(alignment: .leading) {
                    
                    StarRating(rating: averageRating, maxRating: 5).font(.title3).padding(.bottom, 5)
                    HStack {
                        Text("\(viewModel.college.name) - \(viewModel.location.category)")
                            .font(.callout)
                    }.padding(.bottom, 5)
                    
                    Text(viewModel.location.description.isEmpty ? viewModel.college.description : viewModel.location.description)
                        .font(.caption)
                        .fontWeight(.light)
                    
                    LocationImageScrollView(college: viewModel.college, location: viewModel.location)
                        .padding(.horizontal, -20)
                    
                    
                    HStack {
                        Text("Reviews")
                            .font(.title)
                            .fontWeight(.bold)
                        Spacer()
                        Button("Write a Review") {
                            displaySheet.toggle()
                        }
                        .frame(width: 160, height: 40)
                        .background(Color("UniversalFG"))
                        .foregroundColor(Color("UniversalBG"))
                        .bold()
                        .fontWeight(.heavy)
                        .cornerRadius(40)
                        .shadow(radius: 10)
                    }
                    
                    
                    
                    
                    VStack(alignment: .leading) {
                        // if no reviews are in firestore, a single text line is displayed instead of an empty list where reviews otherwise would be
                        if viewModel.reviews.isEmpty {
                            Text("Be the first to review this location")
                        } else {
                            ForEach(viewModel.reviews, id: \.text) { review in
                                let firstChar = Array(review.userID)[0]
                                IndividualReviewView(review: review, firstChar: String(firstChar).uppercased(), isProfilePage: false)
                            } // uses individual review view for consistent formatting throughout
                            
                        }
                    }
                    
                    
                }
                
            }.padding(20)
            
                .sheet(isPresented: $displaySheet) {
                    NewReviewView(viewModel: LocationViewModel(college: viewModel.college, location: viewModel.location), isPresented: $displaySheet) { rating, title, text in
                        viewModel.submitReview(rating: rating, title: title, text: text, forLocation: viewModel.location.id)
                    }
                    .presentationDetents([.fraction(0.4)])
                }
            
            
            
        }
        .onAppear {
            print("Sheet is appearing")
            viewModel.fetchReviewsForLocation(collegeName: viewModel.college.name, locationID: viewModel.location.id)
        }
        .onChange(of: displaySheet) { oldValue, newValue in
            print("Display sheet was just toggled")
            viewModel.fetchReviewsForLocation(collegeName: viewModel.college.name, locationID: viewModel.location.id)
        }
        .onChange(of: viewModel.location.id) { oldValue, newValue in
            print("the locationID just changed")
            viewModel.fetchReviewsForLocation(collegeName: viewModel.college.name, locationID: viewModel.location.id)
        }
    }
}

struct LocationImageScrollView: View {
    var college: College
    var location: Location
    var body: some View {
        GeometryReader(content: { geometry in
            let size = geometry.size
            
            ScrollView(.horizontal) {
                LazyHStack(spacing: 5) {
                    ForEach(1...1, id:\.self) { index in
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
                                        .clipShape(.rect(cornerRadius: 15))
                                        .shadow(color: .black.opacity(0.25), radius: 8, x: 5, y: 10)
                                } else {
                                    AsyncImage(url: URL(string: location.imageLink)) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                    } placeholder: {
                                        Color.black
                                    }
                                    .offset(x: -minX)
                                    .frame(width: proxy.size.width * 1.5)
                                    .frame(width: cardSize.width, height: cardSize.height)
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
                .padding(.horizontal, 60)
                .scrollTargetLayout()
                .frame(height: size.height, alignment: .top)
                
            }
            .scrollTargetBehavior(.viewAligned)
            .scrollIndicators(.hidden)
        })
        .frame(height: 300)
        .padding(.horizontal, -15)
        .padding(.top, 10)
            
        
    }

}


struct StarRating: View {
    struct ClipShape: Shape {
        let width: Double
        
        func path(in rect: CGRect) -> Path {
            Path(CGRect(x: rect.minX, y: rect.minY, width: width, height: rect.height))
        }
    }
    
    let rating: Double
    let maxRating: Int
    
    init(rating: Double, maxRating: Int) {
        self.maxRating = maxRating
        self.rating = rating
    }
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<maxRating, id: \.self) { _ in
                Text(Image(systemName: "star.fill"))
                    .foregroundColor(.gray)
                    .aspectRatio(contentMode: .fill)
                    .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 2)
            }
        }.overlay(
            GeometryReader { reader in
                HStack(spacing: 0) {
                    ForEach(0..<maxRating, id: \.self) { _ in
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .aspectRatio(contentMode: .fit)
                    }
                }
                .clipShape(
                    ClipShape(width: (reader.size.width / CGFloat(maxRating)) * CGFloat(rating))
                )
            }
        )
    }
}
