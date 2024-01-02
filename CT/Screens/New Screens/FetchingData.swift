//
//  FetchingData.swift
//  CT
//
//  Created by Griffin Harrison on 12/30/23.
//

import Foundation
import SwiftUI
import MapKit

class CollegeViewModel: ObservableObject {
    @Published var locations: [Location] = []

    func fetchLocations(forCollege collegeID: String) {
        // Fetch locations from Firestore and update `locations`
    }
}

class LocationViewModel: ObservableObject {
    @Published var reviews: [Review] = []

    func fetchReviews(forLocation locationID: String) {
        // Fetch reviews from Firestore and update `reviews`
    }
}

class ExploreViewModel: ObservableObject {
    @Published var colleges: [College] = []

    func fetchColleges() {
        // Fetch college data from Firestore and update `colleges`
    }
}

// Example CollegeView model for individual college details
class CollegeDetailViewModel: ObservableObject {
    @Published var college: College
    @Published var locations: [Location] = []

    init(college: College) {
        self.college = college
    }

    func fetchLocations() {
        // Fetch locations specific to `college`
    }
}
