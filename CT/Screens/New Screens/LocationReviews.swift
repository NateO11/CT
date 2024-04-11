//
//  LocationReviews.swift
//  CT
//
//  Created by Griffin Harrison on 2/8/24.
//

import Foundation
import SwiftUI
import Firebase
import MapKit


// this is essentially the template/format for each how each individual review displays when a user is reading reviews of a specific location ... this should be standardized and eventually incorporated into forum reviews as well for continuity

struct IndividualReviewView: View {
    let review: Review
    let firstChar: String
    // logic to show/hide lines of a really long review, but not really using this right now
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                /* ZStack {
                    Circle()
                        .fill(Color.black)
                        .frame(width: 35, height: 35)
                    Text(String(firstChar).uppercased())
                        .foregroundStyle(Color.white)
                } */ // results in what looks like a user icon of sorts ... i want to create a system for this that has an associated color for every user or maybe allows profile pictures ... probably a v2 thing
                Image("UVA")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                    .background {
                        Circle()
                            .fill(.black)
                            .padding(-2)
                    }
                
                VStack(alignment: .leading) {
                    Text("\(review.userID)")
                        .font(.subheadline)
                        .foregroundColor(.black)
                    Text("\(formattedDate(review.timestamp))")
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
                Spacer()
                
                HStack(spacing: 5) {
                    ForEach(0..<review.rating, id: \.self) { _ in
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .frame(width: 15)
                            .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 2)
                    }
                    ForEach(review.rating..<5, id: \.self) { _ in
                        Image(systemName: "star.fill")
                            .foregroundColor(.gray)
                            .frame(width: 15)
                            .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 2)
                    }
                    
                } // this creates a horizontal list of stars resembling whatever the associated rating is, yellow stars appear first and gray (if its not 5 star) appear second
                
                
            }
            
            
            .padding(.vertical, 1)

            Text("\(review.title)")
                .font(.headline)
                .bold()
                .foregroundColor(.black)

            
            // calls a function to format the date properly for display

            Text(review.text)
                .font(.callout)
                .foregroundColor(.black)
            // logic to expand the review is not integrated right now but could be down the line

        }
        .padding()
        /* HStack {
            Spacer()
            Rectangle()
                .fill(.black.opacity(0.7))
                .frame(width: 250, height: 2)
            Spacer()
        } */
        
    }
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    } // this takes the review's associated timestamp from firestore and turns it into a text string
}



struct NewReviewView: View {
    @EnvironmentObject var authState: AuthViewModel
    @ObservedObject var viewModel: LocationViewModel
    
    
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
                        Analytics.logEvent("Review", parameters: ["user": authState.currentUser?.fullname ?? "nil","title": titleText,"text": reviewText])
                        isPresented = false
                    } else {
                        showAlert = true
                    }
                }
                    .alert("Must fill out all fields! \nGet a clue lil bro", isPresented: $showAlert, actions: {})
                    .sensoryFeedback(.success, trigger: isPresented)
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


