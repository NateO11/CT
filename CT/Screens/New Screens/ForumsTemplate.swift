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



#Preview {
    ForumsTemplate(college: "college name", forum: "forum name")
}
