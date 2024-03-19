//
//  LocationInfo.swift
//  CT
//
//  Created by Griffin Harrison on 2/8/24.
//

import Foundation
import SwiftUI
import MapKit


// smaller card between the two, takes up 40% of the screen and shows initial information about that location... includes image of school (eventually location image) and button to enter expanded view
/*
struct LocationInitialView: View {
    @EnvironmentObject var authState: AuthState
    @ObservedObject var viewModel: LocationViewModel
    // passes through neccesary information regarding location
    
    @State private var showingReviewSheet = false
    @Environment(\.presentationMode) var presentationMode
    // sheet is dismissed using xbutton rather than native swipe down


    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [colorForCategory(viewModel.location.category), Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea()
                // specific background color based on type of location
                HStack {
                    VStack {
                        Image(viewModel.college.image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 150, height: 200)
                            .cornerRadius(20)
                            .clipped()
                            .padding()
                    } // school image ... will eventually be location specific
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                        VStack {
                            Text(viewModel.location.name)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                                .padding(.top, 10)
                                .padding(.horizontal, 5)
                            Text("\(viewModel.location.name) is a super cool place at \(viewModel.college.name)")
                            // default description ... one will eventually be pulled from firestore
                                .foregroundColor(.black)
                                .padding(.horizontal, 10)
                            Button("Read Reviews!") {
                                showingReviewSheet = true
                            }
                            .frame(width: 160, height: 60)
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(40)
                            .shadow(radius: 10)
                            .padding(10)
                        } // takes user to the expanded view
                    }
                    
                    .padding([.vertical], 30)
                    .padding(.trailing, 20)
                }
            }
        }
        .overlay(alignment: .topTrailing) {
            Button("") {
                self.presentationMode.wrappedValue.dismiss()
            }
            .buttonStyle(xButton())
            .shadow(radius: 10)
            .padding(10)
        } // xbutton used to dismiss, maintains continuity between all map related sheets
        .sheet(isPresented: $showingReviewSheet) {
            LocationExpandedView(viewModel: LocationViewModel(college: viewModel.college, location: viewModel.location, authState: authState))
                .presentationDetents([.fraction(0.99)]) // 0.99 instead of 1 to disable zoom effect
                .presentationDragIndicator(.hidden)
                .interactiveDismissDisabled()
        } // this opens up the expanded info sheet, which contains reviews pulled from firestore
    }
}



// this is the expanded view that shows all the reviews for that specific location ... this sheet takes up the entire screen unlike the initial view which is ~40% ... includes button for user to write a review

struct LocationExpandedView: View {
    @EnvironmentObject var authState: AuthState
    @StateObject var viewModel: LocationViewModel
    // view model lets us pass through necceasry information about the location and relevant firestore related functions
    
    @State private var showingWriteReviewSheet = false
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [colorForCategory(viewModel.location.category), Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea()
            // same as previous screen, gradient color is specific to lcoation's classification
            VStack {
                Image(viewModel.college.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: 150)
                    .clipped()
                    .cornerRadius(10)
                    .padding(.top, 20)
                ZStack { // top rectangle used for basic information about the location
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .padding(.horizontal, 20)
                        .frame(height: 100)
                    VStack(alignment: .leading, spacing: 8) {
                        VStack{
                            Text(viewModel.location.name)
                                .font(.title)
                                .multilineTextAlignment(.center)
                            Text(viewModel.college.name)
                                .font(.headline)
                        }
                        .padding()
                        
                    } // information from initial view is consistent here - same image, name, college name
                    .padding(.horizontal, 40)
                }
                ZStack { // bottom rectangle is an infinite list of reviews for that location
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .padding(.horizontal, 20)
                        .frame(maxHeight: .infinity)
                    VStack {
                        // if no reviews are in firestore, a single text line is displayed instead of an empty list where reviews otherwise would be
                        if viewModel.reviews.isEmpty {
                            Text("Be the first to review this location")
                        } else {
                            List {
                                ForEach(viewModel.reviews, id: \.text) { review in
                                    let firstChar = Array(review.userID)[0]
                                    IndividualReviewView(review: review, firstChar: String(firstChar).uppercased())
                                } // uses individual review view for consistent formatting throughout
                            }.scrollContentBackground(.hidden).padding(.top, -20)
                            // scrolling essentially combines the two rounded rectangles (location info and review list) together visually ... the list also has a transparent background so the gradient beneath is visible
                            Spacer()
                            Spacer()
                        }
                    }
                }
                Spacer()
            }
            .onAppear {
                viewModel.fetchReviewsForLocation(collegeName: viewModel.college.name, locationName: viewModel.location.name)
            } // pulls reviews from firestore using the viewmodel
        }
        .overlay(alignment: .topTrailing) {
            Button("") {
                self.presentationMode.wrappedValue.dismiss()
            }
            .buttonStyle(xButton())
            .shadow(radius: 10)
            .padding(10)
        } // xbutton per usual to dismiss the sheet, you know the drill ... no native dismiss implemented
        .overlay(alignment: .bottom) {
            Button("Write a Review") {
                showingWriteReviewSheet = true
            }
            .frame(width: 160, height: 60)
            .background(Color.black)
            .foregroundColor(.white)
            .cornerRadius(40)
            .shadow(radius: 10)
            .padding()
            .sheet(isPresented: $showingWriteReviewSheet) {
                WriteReviewView(viewModel: LocationViewModel(college: viewModel.college, location: viewModel.location, authState: authState), isPresented: $showingWriteReviewSheet) { rating, title, text in
                    viewModel.submitReview(rating: rating, title: title, text: text, forLocation: viewModel.location.id)
                }
                .presentationDetents([.fraction(0.99)]) // 0.99 instead of 1 to ensure no zoom effect
                .presentationDragIndicator(.hidden)
                .interactiveDismissDisabled()
            }
        } // navigates user to the page where they can write their own review for that location
            
    }
}
*/

struct LocationTestingView: View {
    @EnvironmentObject var authState: AuthViewModel
    @ObservedObject var viewModel: LocationViewModel
    @State private var displaySheet: Bool = false
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(alignment: .leading) {
                HStack {
                    Text(viewModel.location.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .lineLimit(2)
                    Spacer()
                    HStack(spacing: 5) {
                        ForEach(0..<4, id: \.self) { _ in
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                                .frame(width: 15)
                                .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 2)
                        }
                        ForEach(4..<5, id: \.self) { _ in
                            Image(systemName: "star.fill")
                                .foregroundColor(.gray)
                                .frame(width: 15)
                                .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 2)
                        }
                    }
                    
                }.padding(.bottom, 10)
                
                HStack {
                    Text("\(viewModel.college.name) - \(viewModel.location.category)")
                        .font(.callout)
                }.padding(.bottom, 5)
                
                Text(viewModel.college.description)
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
                    .background(Color.black)
                    .foregroundColor(.white)
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
                                IndividualReviewView(review: review, firstChar: String(firstChar).uppercased())
                            } // uses individual review view for consistent formatting throughout
                        
                    }
                }
                
                
            }
            .onAppear {
                viewModel.fetchReviewsForLocation(collegeName: viewModel.college.name, locationName: viewModel.location.name)
            }
        }.padding(20)
        
            .sheet(isPresented: $displaySheet) {
                NewReviewView(viewModel: LocationViewModel(college: viewModel.college, location: viewModel.location), isPresented: $displaySheet) { rating, title, text in
                    viewModel.submitReview(rating: rating, title: title, text: text, forLocation: viewModel.location.id)
                }
                .presentationDetents([.fraction(0.4)])
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
