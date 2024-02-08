//
//  LocationReviews.swift
//  CT
//
//  Created by Griffin Harrison on 2/8/24.
//

import Foundation
import SwiftUI
import MapKit


// this is essentially the template/format for each how each individual review displays when a user is reading reviews of a specific location ... this should be standardized and eventually incorporated into forum reviews as well for continuity

struct IndividualReviewView: View {
    let review: LocationReview
    let firstChar: String
    @State private var expandedReviews: Set<String> = []
    // logic to show/hide lines of a really long review, but not really using this right now
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                ZStack {
                    Circle()
                        .fill(Color.black)
                        .frame(width: 25, height: 25)
                    Text(String(firstChar).uppercased())
                        .foregroundStyle(Color.white)
                } // results in what looks like a user icon of sorts ... i want to create a system for this that has an associated color for every user or maybe allows profile pictures ... probably a v2 thing
                
                Text("\(review.userID)")
                    .font(.subheadline)
                    .foregroundColor(.black)
            }
            
            HStack {
                ForEach(0..<review.rating, id: \.self) { _ in
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                }
                ForEach(review.rating..<5, id: \.self) { _ in
                    Image(systemName: "star.fill")
                        .foregroundColor(.gray)
                }
            } // this creates a horizontal list of stars resembling whatever the associated rating is, yellow stars appear first and gray (if its not 5 star) appear second
            .padding(.vertical, 1)

            Text("\(review.title)")
                .font(.headline)
                .bold()
                .foregroundColor(.black)

            Text("\(formattedDate(review.timestamp))")
                .font(.caption2)
                .foregroundColor(.gray)
                .padding(.bottom, 5)
                .padding(.top, 1)
            // calls a function to format the date properly for display

            Text(review.text)
                .lineLimit(expandedReviews.contains(review.userID) ? nil : 4)
                .font(.body)
                .foregroundColor(.black)
            // logic to expand the review is not integrated right now but could be down the line

        }
        .padding()
    }
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    } // this takes the review's associated timestamp from firestore and turns it into a text string
}



// this view appears when the user clicks the "write a review" button while reading about a location ... once the user adds a rating, title, and body they can submit and the review is then added to firestore

struct WriteReviewView: View {
    @StateObject var viewModel: LocationCardViewModel
    // view model includes functions neccesary to relay the reviews back and forth between firestore, although I want to make some small changes to the review data is sent to the associated user as well as the associated location, where it can then be accessed on the user's profile page
    
    @Binding var isPresented: Bool {
        didSet {
            viewModel.fetchReviewsForLocation(collegeName: viewModel.college.name, locationName: viewModel.location.name)
        }
    } // in theory this should refresh the reviews page when the new review is submitted, but now that I'm thinking about it I think this logic needs to occur in the location expanded info view
    @State private var rating: Int = 0
    @State private var titleText: String = ""
    @State private var reviewText: String = ""
    @State private var showAlert: Bool = false
    var onSubmit: (Int, String, String) -> Void

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [colorForCategory(viewModel.location.category), Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea()
            // background color stays the same from the previous two pages
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .padding(.horizontal, 20)
                        .frame(height: 100)
                    HStack {
                        Image(viewModel.college.image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 80, height: 80)
                            .clipped()
                            .cornerRadius(10)
                        VStack(alignment: .leading) {
                            Text(viewModel.location.name)
                                .font(.title)
                            Text("\(viewModel.college.name) - \(viewModel.college.city)")
                                .font(.headline)
                        } // need to work on the exact formatting for this top section but I like the idea of having basic information reminding the user what location they are on
                    }.padding(.horizontal, 25)
                }
                .padding(.top, 20)
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .padding(.horizontal, 20)
                    VStack {
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
                        } // changes the rating based on how many stars the user selects 1-5
                        .padding(.bottom, 10)
                        VStack(alignment: .leading) {
                            Text("Title your review")
                                .font(.headline)
                            TextField("Title", text: $titleText)
                                .padding(5)
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black))
                            Text("Write your review")
                                .font(.headline)
                            ZStack(alignment: .topLeading) {
                                TextEditor(text: $reviewText)
                                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black))
                                if reviewText == "" {
                                    Text("Tell us what you think!")
                                        .foregroundStyle(Color.gray.opacity(0.6))
                                        .padding(.horizontal, 4)
                                        .padding(.vertical, 8)
                                } // you can't have preview text showing up in a texteditor like you can in a textfield, so this solves that issue by checking if the texteditor is blank and then overlaying some preview text until the user types
                            }
                        }
                        Button("Submit") {
                            if titleText != "" && reviewText != "" {
                                onSubmit(rating + 1, titleText, reviewText)
                                isPresented = false
                            } else {
                                showAlert = true
                            } // submits the review and sends it to firestore
                        }.alert("Must fill out all fields! \nGet a clue lil bro", isPresented: $showAlert, actions: {})
                        .frame(width: 160, height: 60)
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(40)
                        .shadow(radius: 10)
                        .padding()
                    } // if fields are left blank, a popup displays politely reminding the user to fill everything out
                    .padding(30)
                    
                }
                Spacer()
            }
        }
        .overlay(alignment: .topTrailing) {
            Button("") {
                isPresented = false
            }
            .buttonStyle(xButton())
            .shadow(radius: 10)
            .padding(10)
        } // xbutton used to close sheet instead of native dragging feature ... adds to continuity between all the location sheets
    }
}


#Preview {
    ExploreView(viewModel: ExploreViewModel(), ID: "placeholder")
}

