//
//  FourmsTemplate.swift
//  CT
//
//  Created by Nate Owen on 1/6/24.
//

//
//  FourmsTemplate.swift
//  CT
//
//  Created by Nate Owen on 1/6/24.
//

import SwiftUI

struct ForumsTemplate: View {
    @StateObject private var viewModel = ForumViewModel()
    @State private var collegeName: String = "Virginia Tech"
    @State private var forumName: String = "Greek"
    
    init(college: String, forum: String) {
        _collegeName = State(initialValue: college)
        _forumName = State(initialValue: forum)
    }
    
    
    var body: some View {
    
            VStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 8) {
                    VStack{
                        Text("\(collegeName)")
                            .font(.title2)
                        Text("\(forumName)")
                            .font(.caption)
                    }
                }
                .padding(.horizontal, 40)
                
                Spacer() // Push the VStack to the left
                
                ForumReviewListView(reviews: viewModel.reviews)
                    .padding(.bottom)
                
                
            }
            
        NavigationLink(destination: ProfilePage(userID: "4xLrvkubquPQIVNSrUrGCW1Twhi2")) {
                VStack {
                    
                    Text("Write a Review")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black)
                        .cornerRadius(20)
                }
            }
            .onAppear {
                viewModel.fetchReviews(forCollege: collegeName, forumName: forumName)
            }
        }
        
    }



struct ForumReviewListView: View {
    var reviews: [(user: String, time: Date, reviewTitle: String, review: String, rating: Int)]

    @State private var expandedReviews: Set<String> = []
    

    var body: some View {
        List {
            ForEach(reviews, id: \.review) { review in
                let firstChar = Array(review.user)[0]
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        ZStack {
                            Circle()
                                .fill(Color.black)
                                .frame(width: 25, height: 25)
                            Text(String(firstChar).uppercased())
                                .foregroundStyle(Color.white)
                        }
                        Text("\(review.user)")
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
                    }
                    .padding(.vertical, 1)

                    Text("\(review.reviewTitle)")
                        .font(.headline)
                        .bold()
                        .foregroundColor(.black)

                    Text("\(formattedDate(review.time))")
                        .font(.caption2)
                        .foregroundColor(.gray)
                        .padding(.bottom, 5)
                        .padding(.top, 1)

                    Text(review.review)
                        .lineLimit(expandedReviews.contains(review.user) ? nil : 4) // Show all lines if expanded
                        .font(.body)
                        .foregroundColor(.black)

                    Button(action: {
                        toggleReadMore(review.user)
                    }) {
                        Text(expandedReviews.contains(review.user) ? "Read Less" : "Read More")
                            .font(.caption)
                            .foregroundColor(.blue)
                            .padding(.top, 5)
                    }
                }
                .padding()
            }
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0)) // Adjust the bottom inset as needed

            // Add a Spacer view between each VStack
            Spacer().frame(height: 10)
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }

    private func toggleReadMore(_ user: String) {
        if expandedReviews.contains(user) {
            expandedReviews.remove(user)
        } else {
            expandedReviews.insert(user)
        }
    }
}

#Preview {
    ForumsTemplate(college: "college name", forum: "forum name")
}
