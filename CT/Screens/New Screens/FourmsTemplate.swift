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

struct FourmsTemplate: View {
    @StateObject private var viewModel = ForumViewModel()
    @State private var collegeName: String = "Virginia Tech"
    @State private var forumName: String = "Greek"
    
    init(college: String, forum: String) {
          _collegeName = State(initialValue: college)
          _forumName = State(initialValue: forum)
      }

    
    var body: some View {
        VStack {
            Text(collegeName)
                .font(.headline)

            Text(forumName)
                .font(.caption)
                

            ForumReviewListView(reviews: viewModel.reviews)
                .padding()
        }
        .onAppear {
            viewModel.fetchReviews(forCollege: collegeName, forumName: forumName)
        }
    }
}


#Preview {
    FourmsTemplate(college: "college name", forum: "forum name")
}
