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

