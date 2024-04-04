//
//  Forum.swift
//  CT
//
//  Created by Griffin Harrison on 4/3/24.
//

import Foundation
import SwiftUI
import MapKit


struct ForumView: View {
    @EnvironmentObject var authState: AuthViewModel
    @ObservedObject var viewModel: ForumViewModel
    @State private var displaySheet: Bool = false
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(alignment: .leading) {
                HStack {
                    Text("\(viewModel.info.category) - Forum")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .lineLimit(2)
                    Spacer()
                    
                    
                }.padding(.bottom, 10)
                
                HStack {
                    Text("\(viewModel.college.name) - \(viewModel.info.classification)")
                        .font(.callout)
                }.padding(.bottom, 5)
                
                
                
                
                
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
                            IndividualReviewView(review: review, firstChar: String(firstChar).uppercased())
                        } // uses individual review view for consistent formatting throughout
                        
                    }
                }
                
                
            }
            .onAppear {
                viewModel.fetchReviewsForInfo(collegeName: viewModel.college.name, infoName: viewModel.info.category)
            }
            .onChange(of: displaySheet) { oldValue, newValue in
                viewModel.fetchReviewsForInfo(collegeName: viewModel.college.name, infoName: viewModel.info.category)
            }
        }.padding(20)
        
            .sheet(isPresented: $displaySheet) {
                NewForumReviewView(viewModel: ForumViewModel(college: viewModel.college, info: viewModel.info), isPresented: $displaySheet) { rating, title, text in
                    viewModel.submitReview(rating: rating, title: title, text: text, forInfo: viewModel.info.category)
                }
                .presentationDetents([.fraction(0.4)])
            }
        
        
        
    }

}


struct NewForumReviewView: View {
    @EnvironmentObject var authState: AuthViewModel
    @ObservedObject var viewModel: ForumViewModel
    
    
    @Binding var isPresented: Bool
    @State private var rating: Int = -1
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
                    if titleText != "" && reviewText != "" && rating != -1 {
                        onSubmit(rating + 1, titleText, reviewText)
                        isPresented = false
                    } else {
                        showAlert = true
                    }
                }.alert("Must fill out all fields! \nGet a clue lil bro", isPresented: $showAlert, actions: {})
            }
            HStack {
                ForEach(0..<5) {value in
                    Image(systemName: "star.fill")
                        .resizable()
                        .frame(width: 25,height: 25)
                        .foregroundColor(self.rating >= value ? .yellow : .gray)
                        .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 2)
                        .onTapGesture {
                            self.rating = value
                        }
                }
            }
            .padding(.bottom,5)
            Rectangle()
                .fill(.black.opacity(0.3))
                .frame(height: 1)
            TextField("Title", text: $titleText)
                .textFieldStyle(.automatic)
                .font(.title2)
            Rectangle()
                .fill(.black.opacity(0.3))
                .frame(height: 1)
            TextField("Review", text: $reviewText)
                .textFieldStyle(.automatic)
                .font(.title2)
            Spacer()
            
        }
        .padding()
    }
}


