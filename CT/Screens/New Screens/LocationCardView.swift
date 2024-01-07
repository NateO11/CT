//
//  LocationCardView.swift
//  CT
//
//  Created by Nate Owen on 1/7/24.
//
import SwiftUI

struct LocationCardView: View {
    @ObservedObject var viewModel: LocationCardViewModel
    let collegeName: String
    let locationName: String

    var body: some View {
        VStack {
            Text("\(collegeName)")
            Text("\(locationName)")
            
            if let locationName = viewModel.locationName {
                Text("Fetched Category Name: \(locationName)")
            } else {
                Text("Loading...")
                    .onAppear {
                        viewModel.fetchLocationName(forCollege: collegeName, locationName: locationName)
                    }
            }
        }
        .padding()
        .onAppear {
            // You can add additional logic or actions when the view appears
        }
    }
}
#Preview{
    LocationCardView(viewModel: LocationCardViewModel(), collegeName: "University of Virginia", locationName: "The Park")
}
