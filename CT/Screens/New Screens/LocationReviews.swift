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
    let isProfilePage: Bool
    let isStars: Bool
    // logic to show/hide lines of a really long review, but not really using this right now
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(review.userInitials)
                    .font(.callout)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(width: 40,height: 40)
                    .background(Color(.systemGray3))
                    .clipShape(Circle())
                    .background {
                        Circle()
                            .fill(.white)
                            .padding(-2)
                    }
                
                VStack(alignment: .leading) {
                    if isProfilePage {
                        Text("\(review.schoolName) - \(review.locationName)")
                            .font(.subheadline)
                            .foregroundColor(Color("UniversalFG"))
                    } else {
                        Text("\(review.userName)")
                            .font(.subheadline)
                            .foregroundColor(Color("UniversalFG"))
                    }
                    Text("\(formattedDate(review.timestamp))")
                        .font(.caption2)
                        .foregroundColor(Color("UniversalFG").opacity(0.7))
                }
                Spacer()
                
                if isStars {
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
                
            }
            
            
            .padding(.vertical, 1)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("\(review.title)")
                        .font(.headline)
                        .bold()
                        .foregroundColor(Color("UniversalFG"))

                    
                    // calls a function to format the date properly for display

                    Text(review.text)
                        .font(.callout)
                        .foregroundColor(Color("UniversalFG"))
                    // logic to expand the review is not integrated right now but could be down the line

                }
                Spacer()
                if isProfilePage == false {
                    VStack {
                        Spacer()
                        Menu {
                            Button {
                                reportReview(userID: review.userID)
                            } label: {
                                HStack(spacing: 5) {
                                    Image(systemName: "exclamationmark.bubble")
                                    Text("Report Comment")
                                }.tint(.red)
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                                .font(.title)
                                .foregroundColor(Color("UniversalFG"))
                        }
                    }
                }
            }

            
        }
        .padding()
        
    }
    private func reportReview(userID: String) {
        let db = Firestore.firestore()
        let usersRef = db.collection("Users").document(userID)
        
        usersRef.updateData([
                "reports": FieldValue.increment(Int64(1))
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
            }
        print("Reported user \(userID)")
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


