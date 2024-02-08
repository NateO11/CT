//
//  LocationInfo.swift
//  CT
//
//  Created by Griffin Harrison on 2/8/24.
//

import Foundation
import SwiftUI
import MapKit

struct LocationInitialView: View {
    @ObservedObject var locationViewModel: LocationViewModel
    let location: Location
    @State private var showingReviewSheet = false
    @Environment(\.presentationMode) var presentationMode


    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [colorForCategory(location.category), Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea()
                HStack {
                    VStack {
                        Image(locationViewModel.college.image) // Assuming imageName is the name of the image in the assets
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 150, height: 200)
                            .cornerRadius(20)
                            .clipped()
                            .padding()
                    }
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white)
                            VStack {
                                Text(location.name)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                                    .multilineTextAlignment(.center)
                                    .padding(.top, 10)
                                    .padding(.horizontal, 5)
                                Text("\(location.name) is a super cool place at \(locationViewModel.college.name)")
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
                                }
                            }
                        
                        .padding([.vertical], 30)
                    .padding(.trailing, 20)
                    }
                }
            }
            .overlay(alignment: .topTrailing) {
                Button("") {
                    self.presentationMode.wrappedValue.dismiss()
                    // this should dismiss the sheet
                }
                .buttonStyle(xButton())
                .shadow(radius: 10)
                .padding(10)
        
        }
            .sheet(isPresented: $showingReviewSheet) {
                // This is the sheet presentation
                LocationExpandedView(viewModel: LocationCardViewModel(college: locationViewModel.college, location: location))
                    .presentationDetents([.fraction(0.99)])
                    .presentationDragIndicator(.hidden)
                    .interactiveDismissDisabled()
            }
    }
}


struct LocationExpandedView: View {
    @StateObject var viewModel: LocationCardViewModel
    @State private var showingWriteReviewSheet = false
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [colorForCategory(viewModel.location.category), Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea()
            VStack {
                Image(viewModel.college.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: 150)
                    .clipped()
                    .cornerRadius(10)
                    .padding(.top, 20)
                ZStack {
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
                        
                    }
                    .padding(.horizontal, 40)
                }
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .padding(.horizontal, 20)
                        .frame(maxHeight: .infinity)
                    VStack {
                        if viewModel.reviews.isEmpty {
                            Text("Be the first to review this location")
                        } else {
                            List {
                                ForEach(viewModel.reviews, id: \.text) { review in
                                    let firstChar = Array(review.userID)[0]
                                    IndividualReviewView(review: review, firstChar: String(firstChar).uppercased())
                                }
                            }.scrollContentBackground(.hidden).padding(.top, -20)
                            Spacer()
                            Spacer()
                        }
                    }
                }
                Spacer()
            }
            .onAppear {
                viewModel.fetchReviewsForLocation(collegeName: viewModel.college.name, locationName: viewModel.location.name)
            }
        }
        .overlay(alignment: .topTrailing) {
            Button("") {
                self.presentationMode.wrappedValue.dismiss()
                // this should dismiss the sheet
            }
            .buttonStyle(xButton())
            .shadow(radius: 10)
            .padding(10)
        }
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
                WriteReviewView(viewModel: LocationCardViewModel(college: viewModel.college, location: viewModel.location), isPresented: $showingWriteReviewSheet) { rating, title, text in
                    viewModel.submitReview(rating: rating, title: title, text: text, forLocation: viewModel.location.id)
                }
                .presentationDetents([.fraction(0.99)])
                .presentationDragIndicator(.hidden)
                .interactiveDismissDisabled()
            }
        }
            
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }
}


#Preview {
    ExploreView(viewModel: ExploreViewModel(), ID: "placeholder")
}

