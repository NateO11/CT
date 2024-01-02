//
//  Views.swift
//  CT
//
//  Created by Griffin Harrison on 12/30/23.
//

import Foundation
import SwiftUI
import MapKit

struct MapView: View {
    @ObservedObject var viewModel: CollegeViewModel
    // Assume you have a way to represent locations on the map

    var body: some View {
        // Your map view implementation
        // Add onTapGesture to markers to navigate to LocationDetailView
    }
}

struct LocationDetailView: View {
    @ObservedObject var locationViewModel: LocationViewModel
    let location: Location
    @State private var showingReviewSheet = false

    var body: some View {
        VStack {
            // Existing content
            Button("Write a Review") {
                showingReviewSheet = true
            }
            .sheet(isPresented: $showingReviewSheet) {
                WriteReviewView(isPresented: $showingReviewSheet) { rating, text in
                    locationViewModel.submitReview(rating: rating, text: text, forLocation: location.id)
                }
            }
        }
    }
}


struct ReviewView: View {
    let review: Review

    var body: some View {
        // Layout for displaying the review
    }
}

struct ExploreView: View {
    @ObservedObject var viewModel: ExploreViewModel

    var body: some View {
        NavigationView {
            List(viewModel.colleges) { college in
                NavigationLink(destination: SchoolView(viewModel: CollegeDetailViewModel(college: college))) {
                    CollegeRow(college: college)
                }
            }
            .navigationTitle("Explore Colleges")
        }
        .onAppear {
            viewModel.fetchColleges()
        }
    }
}

struct CollegeRow: View {
    let college: College

    var body: some View {
        HStack {
            // Display college info, e.g., name, image
        }
    }
}

struct SchoolViewNew: View {
    @ObservedObject var viewModel: CollegeDetailViewModel

    var body: some View {
        ScrollView {
            VStack {
                CollegeInfoView(college: viewModel.college)
                MapView(viewModel: viewModel)
            }
        }
        .navigationTitle(viewModel.college.name)
        .onAppear {
            viewModel.fetchLocations()
        }
    }
}

struct CollegeInfoView: View {
    let college: College

    var body: some View {
        VStack(alignment: .leading) {
            Text(college.name).font(.title)
            // Display other college details
        }
    }
}
