//
//  LocationCardView.swift
//  CT
//
//  Created by Nate Owen on 1/7/24.
//


import SwiftUI

struct LocationCardView: View {
    @StateObject var viewModel = LocationCardViewModel()
    let collegeName = "University of Virginia"
    let locationName = "Clark Library"

    var body: some View {
        
        ScrollView{
        
            VStack {
                
                Image("UVA")
                
                VStack(alignment: .leading, spacing: 8) {
                    
                    VStack{
                        
                        Text(locationName)
                            .font(.title)
                        
                        Text(collegeName)
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
                viewModel.fetchReviewsForLocation(collegeName: collegeName, locationName: locationName)
            }
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }
   }


#Preview{
    LocationCardView()
}
