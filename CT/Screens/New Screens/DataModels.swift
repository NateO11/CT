//
//  DataModels.swift
//  CT
//
//  Created by Griffin Harrison on 12/30/23.
//

import Foundation
import SwiftUI
import MapKit
import FirebaseFirestore


struct College: Identifiable {
    let id: String
    let available: Bool
    let name: String
    let city: String
    let description: String
    let image: String
    // Other college properties
}

struct Location: Identifiable {
    let id: String
    let name: String
    let description: String
    let coordinate: CLLocationCoordinate2D
    let category: String
    // Other location properties
}

struct Review: Identifiable {
    let id: String
    let userID: String
    let rating: Int
    let text: String
    let timestamp: Date
    // Other review properties
}

struct LocationReview {
    let text: String
    let rating: Int
    let userID: String
    let title: String
    let timestamp: Date
}
