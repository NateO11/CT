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

struct Review {
    var reviewerName: String
    var rating: Int
    var comments: String
}

struct ReviewSubmissionForm: View {
    var firestoreLocation: FirestoreLocation
    var onReviewSubmit: (FirestoreReview) -> Void

    @State private var reviewerName = ""
    @State private var rating = 3
    @State private var comments = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Review Details")) {
                    TextField("Your Name", text: $reviewerName)
                    Stepper(value: $rating, in: 1...5, label: {
                        Text("Rating: \(rating)")
                    })
                    TextEditor(text: $comments)
                }

                Section {
                    Button("Submit Review") {
                        // Validate input and submit the review to Firebase
                        let newReview = FirestoreReview(reviewerName: reviewerName, rating: rating, comments: comments)
                        onReviewSubmit(newReview)
                    }
                }
            }
            .navigationTitle("Write a Review")
        }
    }
}

struct ReviewDisplayView: View {
    var firestoreLocation: FirestoreLocation?

    var body: some View {
        if let firestoreLocation = firestoreLocation {
            VStack(spacing: 20) {
                Text(firestoreLocation.name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top, 10)
                    .foregroundColor(.white)

                // Display reviews for the selected location
                List(firestoreLocation.reviews, id: \.reviewerName) { review in
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            Text("\(review.reviewerName)")
                                .font(.headline)
                                .foregroundColor(.blue)
                            Spacer()
                            Text("\(review.rating) stars")
                                .font(.subheadline)
                                .foregroundColor(.yellow)
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
                    .fill(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.black]), startPoint: .topLeading, endPoint: .bottomTrailing))
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

