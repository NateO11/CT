//
//  LocationCardView.swift
//  CT
//
//  Created by Nate Owen on 1/7/24.
//


import SwiftUI

struct LocationCardView: View {
    @StateObject var viewModel = LocationCardViewModel()
    var college: College
    var location: Location

    var body: some View {
        
        ScrollView{
        
            VStack {
                
                Image("UVA")
                
                VStack(alignment: .leading, spacing: 8) {
                    
                    VStack{
                        
                        Text(location.name)
                            .font(.title)
                        
                        Text(college.name)
                            .font(.headline)
                    }
                    .padding()
                   
                    /// use the forum jaunt
                    
                        ForEach(viewModel.reviews, id: \.text) { review in
                            VStack {
                                Text(review.text)
                                    .padding()
                                Text("\(review.rating)")
                                Text("\(review.userID)")
                                Text("\(formattedDate(review.timestamp))")
                                Divider()
                            }
                    }
                }
                .padding(.horizontal, 40)
 
            }
            .onAppear {
                viewModel.fetchReviewsForLocation(collegeName: college.name, locationName: location.name)
            }
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }
   }
