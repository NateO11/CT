//
//  OldVersionsOfScreens.swift
//  CT
//
//  Created by Griffin Harrison on 1/12/24.
//

import Foundation
import SwiftUI
import MapKit


// Old version of locationDetailView ...  please keep for reference
/* struct LocationDetailView: View {
    @ObservedObject var locationViewModel: LocationViewModel
    let location: Location
    @State private var showingReviewSheet = false
    @Environment(\.presentationMode) var presentationMode


    var body: some View {
        VStack {
            ZStack {
                HStack {
                    /* Button("") {
                    }
                    .buttonStyle(CategoryButton(category: location.category, dimensions: 12))
                    .padding(.trailing, 10)
                    Spacer()
                     */
                    Text(location.name)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .lineLimit(2)
                }
                HStack {
                    
                }
                HStack {
                    Spacer()
                    Button("") {
                        self.presentationMode.wrappedValue.dismiss()
                        // this should dismiss the sheet
                    }
                        .buttonStyle(xButton())
                        .padding(.leading, 10)
                    
                }
            }
            .padding()
                
            
            List(locationViewModel.reviews) { review in
                ReviewView(review: review)
            }
            .listStyle(PlainListStyle())
            .padding(.horizontal, -20)
            .padding(.top, 20)
            Button("Write a Review") {
                showingReviewSheet = true
            }
            .frame(width: 160, height: 60)
            .background(Color.blue.opacity(0.5))
            .foregroundColor(.white)
            .cornerRadius(40)
            .padding()
            .sheet(isPresented: $showingReviewSheet) {
                WriteReviewView(isPresented: $showingReviewSheet) { rating, text in
                    locationViewModel.submitReview(rating: rating, text: text, forLocation: location.id)
                }
                .presentationDetents([.medium])
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .opacity(0.8)
        )
        .onAppear {
            locationViewModel.fetchReviews(forLocation: location.id)
        }
    }
}
 
 */


/* Old review view version ... keep for reference
struct OldReviewView: View {
    let review: Review

    var body: some View {
        // Layout for displaying the review
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text("\(review.userID)")
                    .font(.headline)
                    .foregroundColor(.blue)
                Spacer()
                Text("\(review.rating) stars")
                    .font(.subheadline)
                    .foregroundColor(.yellow)
            }
            Text(review.text)
                .font(.body)
                .foregroundColor(.black)
        }
        .padding(10)
        .background(Color.clear)
        .padding(.vertical, 5)
    }
}


struct NewReviewView: View {
    let review: LocationReview

    var body: some View {
        // Layout for displaying the review
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text("\(review.userID)")
                    .font(.headline)
                    .foregroundColor(.blue)
                Spacer()
                Text("\(review.rating) stars")
                    .font(.subheadline)
                    .foregroundColor(.yellow)
            }
            Text(review.title)
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundStyle(Color.black)
            Text(review.text)
                .font(.body)
                .foregroundColor(.black)
        }
        .padding(.horizontal, 25)
        .background(Color.clear)
        .padding(.vertical, 5)
    }
}
*/


/*
struct OldWriteReviewView: View {
    @Binding var isPresented: Bool
    @State private var rating: Int = 0
    @State private var titleText: String = ""
    @State private var reviewText: String = ""
    var onSubmit: (Int, String, String) -> Void

    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    HStack {
                        Spacer()
                    }
                    HStack {
                        Text("Write review")
                            .font(.title
                                .bold())
                    }
                    HStack {
                        Spacer()
                        Button("") {
                            isPresented = false
                        }
                            .buttonStyle(xButton())
                            .shadow(radius: 10)
                        
                    }
                }
                .padding()
                HStack {
                    ForEach(0..<5) {value in
                        Image(systemName: "star.fill")
                            .resizable()
                            .frame(width: 30,height: 30)
                            .foregroundColor(self.rating >= value ? .yellow : .gray)
                            .onTapGesture {
                                self.rating = value
                            }
                    }
                }
                TextEditor(text: $titleText)
                    .frame(minHeight: 20)
                    .border(Color.black)
                    .padding()
                
                TextEditor(text: $reviewText)
                    .frame(minHeight: 200)
                    .border(Color.black)
                    .padding()
                   
                
                Button("Submit") {
                    onSubmit(rating + 1, titleText, reviewText)
                    isPresented = false
                }
                .frame(width: 160, height: 60)
                .background(Color.blue.opacity(0.5))
                .foregroundColor(.white)
                .cornerRadius(40)
                .padding()
            }
        }
    }
}
 
 struct HorizontalSchoolsScrollView: View {
     var colleges: [College]

     var body: some View {
         ScrollView(.horizontal, showsIndicators: false) {
             LazyHStack(spacing: 5) {
                 ForEach(colleges, id: \.id) { college in
                     NavigationLink(destination: SchoolView(viewModel: CollegeDetailViewModel(college: college))) {
                         SchoolCard(college: college)
                     }
                 }
             }
             .padding(.horizontal)
             .scrollTargetLayout()
         }
         .scrollTargetBehavior(.viewAligned)
         
     }
 }
 
 struct SchoolView: View {
     @ObservedObject var viewModel: CollegeDetailViewModel

     var body: some View {
         NavigationStack {
             ScrollView {
                 VStack(alignment: .leading, spacing: 10) {
                     Spacer().frame(height: 90)
                     
                     // Horizontal Scroll of Photos
                     ScrollView(.horizontal, showsIndicators: false) {
                         HStack(spacing: 10) {
                             ForEach(1..<5) { _ in
                                 Image(viewModel.college.image)
                                     .resizable()
                                     .aspectRatio(contentMode: .fill)
                                     .frame(width: 300, height: 200)
                                     .clipped()
                                     .cornerRadius(10)
                             }
                         }
                     }
                     .frame(height: 200)
                     .padding(.bottom, 5) // Adjust spacing as needed
 
 
 */
