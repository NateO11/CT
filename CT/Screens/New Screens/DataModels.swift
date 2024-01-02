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

let defaultPosition = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 38.04272231323672, longitude: -78.50961596590895), span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.022)))
