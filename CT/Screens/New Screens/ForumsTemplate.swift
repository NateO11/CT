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
    @ObservedObject var viewModel: ForumViewModel

    
    var body: some View {
    
            VStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 8) {
                    VStack{
                        Text("\(viewModel.college.name)")
                            .font(.title2)
                        Text("\(viewModel.forum)")
                            .font(.caption)
                    }
                }
                .padding(.horizontal, 40)
                
                Spacer() // Push the VStack to the left
                
                ForumReviewListView(viewModel: viewModel)
                    .padding(.bottom)
                
                
            }
            
        NavigationLink(destination: ProfilePage(profileViewModel: ProfileViewModel())) {
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
                viewModel.fetchReviews(forCollege: viewModel.college, forumName: viewModel.forum)
            }
        }
        
    }



struct ForumReviewListView: View {
    @StateObject var viewModel: ForumViewModel

    @State private var expandedReviews: Set<String> = []
    

    var body: some View {
        VStack {
            List {
                ForEach(viewModel.reviews, id: \.text) { review in
                    let firstChar = Array(review.userID)[0]
                    IndividualReviewView(review: review, firstChar: String(firstChar).uppercased())
                        .padding()
                }
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0)) // Adjust the bottom inset as needed
                
                // Add a Spacer view between each VStack
                Spacer().frame(height: 10)
            }
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


