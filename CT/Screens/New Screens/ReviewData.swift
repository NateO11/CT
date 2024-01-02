//
//  ReviewData.swift
//  CT
//
//  Created by Griffin Harrison on 12/30/23.
//

import Foundation
import SwiftUI
import MapKit

struct WriteReviewView: View {
    @Binding var isPresented: Bool
    @State private var rating: Int = 0
    @State private var reviewText: String = ""
    var onSubmit: (Int, String) -> Void

    var body: some View {
        NavigationView {
            Form {
                Picker("Rating", selection: $rating) {
                    ForEach(1...5, id: \.self) {
                        Text("\($0) Stars")
                    }
                }
                TextEditor(text: $reviewText)
                    .frame(minHeight: 200)
            }
            .navigationTitle("Write Review")
            .navigationBarItems(leading: Button("Cancel") {
                isPresented = false
            }, trailing: Button("Submit") {
                onSubmit(rating, reviewText)
                isPresented = false
            })
        }
    }
}

extension LocationViewModel {
    func submitReview(rating: Int, text: String, forLocation locationID: String) {
        // Construct a Review object and submit to Firestore
        // Update the local `reviews` array to reflect the new review
    }
}

extension CollegeDetailViewModel {
    func submitReview(rating: Int, text: String, forCollege collegeID: String) {
        // Similar implementation for college reviews
    }
}

