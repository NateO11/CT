//
//  MapReviewManager.swift
//  CT
//
//  Created by Griffin Harrison on 12/28/23.
//

import SwiftUI
import MapKit
import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore


struct ReviewSubmissionForm: View {
    var firestoreLocation: FirestoreLocation
    var onReviewSubmit: (FirestoreReview) -> Void

    @State private var rating = 3
    @State private var comments = ""
    @State private var user = UserProfile(name: "Nate Owen", school: "Swift University", profilePicture: "UVA")
    
    var body: some View {
            NavigationView {
                VStack(spacing: 20) {
                    Text(firestoreLocation.name)
                        .font(.largeTitle)
                        .bold()

                    // Star Rating
                    HStack {
                        ForEach(1...5, id: \.self) { index in
                            Image(systemName: rating >= index ? "star.fill" : "star")
                                .foregroundColor(rating >= index ? .yellow : .gray)
                                .onTapGesture {
                                    rating = index
                                }
                        }
                    }
                    .font(.largeTitle)
                    .padding()

                    // Review TextEditor
                    TextEditor(text: $comments)
                        .frame(height: 200)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                        .padding()

                    // Submit Button
                    Button(action: {
                        // Validate and Submit Review
                        let newReview = FirestoreReview(reviewerName: user.name, rating: rating, comments: comments)
                        onReviewSubmit(newReview)

                        // Clear the comments after submission
                        comments = ""
                        rating = 0
                    }) {
                        Text("Submit Review")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.black)
                            .cornerRadius(8)
                            .padding(.trailing, 20)
                            .padding(.bottom, 20)
                    }
                    .padding()

                    Spacer()
                }
                .padding()
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    
    
}

struct ReviewDisplayView: View {
    var firestoreLocation: FirestoreLocation?

    var body: some View {
        if let firestoreLocation = firestoreLocation {
            VStack(spacing: 20) {
                Text("Student reviews - \(firestoreLocation.name)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top, 10)
                    .foregroundColor(.white)

                // Display reviews for the selected location
                List(firestoreLocation.reviews, id: \.id) { review in
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            Text("\(review.reviewerName)")
                                .font(.headline)
                                .foregroundColor(.blue)
                            Spacer()
                            ForEach(1...5, id: \.self) { index in
                                Image(systemName: review.rating >= index ? "star.fill" : "star")
                                    .foregroundColor(review.rating >= index ? .yellow : .gray)
                            }
                        }
                        Text(review.comments)
                            .font(.body)
                            .foregroundColor(.black)
                    }
                    .padding(10)
                    .background(Color.clear)
                    .padding(.vertical, 5)
                }
                .listStyle(PlainListStyle())
                .padding(.horizontal, -20) // Reduce default list padding
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.white]), startPoint: .topLeading, endPoint: .bottomLeading))
                    .opacity(0.8)
            )
            .cornerRadius(15)
            .shadow(radius: 5)
        } else {
            Text("Unknown location")
                .font(.title)
                .foregroundColor(.red)
                .padding()
        }
    }
}

