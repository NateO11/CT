//
//  MapLocationManager.swift
//  CT
//
//  Created by Griffin Harrison on 12/28/23.
//
import SwiftUI
import MapKit
import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore


struct Location: Identifiable {
    // defining a struct so i can manage location data
    let id = UUID()
    var name: String
    var coordinate: CLLocationCoordinate2D
    var category: String
    var reviews: [Review]
}


let defaultPosition = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 38.04272231323672, longitude: -78.50961596590895), span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.022)))

var locations: [Location] = [
    Location(name: "Rotunda", coordinate: CLLocationCoordinate2D(latitude: 38.03572266, longitude: -78.50347772), category: "Landmarks", reviews: [Review(reviewerName: "User", rating: 3, comments: "It's ok"), Review(reviewerName: "User", rating: 3, comments: "It's ok"), Review(reviewerName: "User", rating: 3, comments: "It's ok"), Review(reviewerName: "User", rating: 3, comments: "It's ok")]),
    Location(name: "Newcomb Hall", coordinate: CLLocationCoordinate2D(latitude: 38.03588304, longitude: -78.50646150), category: "Dining", reviews: [Review(reviewerName: "User", rating: 3, comments: "It's ok")]),
    Location(name: "Observatory Hill", coordinate: CLLocationCoordinate2D(latitude: 38.03483691, longitude: -78.51518898), category: "Dining", reviews: [Review(reviewerName: "User", rating: 3, comments: "It's ok")]),
    Location(name: "Runk Dining Hall", coordinate: CLLocationCoordinate2D(latitude: 38.02896428, longitude: -78.51879371), category: "Dining", reviews: [Review(reviewerName: "User", rating: 3, comments: "It's ok")]),
    Location(name: "Aquatic and Fitness Center", coordinate: CLLocationCoordinate2D(latitude: 38.03295801, longitude: -78.51358269), category: "Athletics", reviews: [Review(reviewerName: "User", rating: 3, comments: "It's ok")]),
    Location(name: "Memorial Gym", coordinate: CLLocationCoordinate2D(latitude: 38.03788988, longitude: -78.50698443), category: "Athletics", reviews: [Review(reviewerName: "User", rating: 3, comments: "It's ok")]),
    Location(name: "Slaughter Recreation Center", coordinate: CLLocationCoordinate2D(latitude: 38.03511977, longitude: -78.51757275), category: "Athletics", reviews: [Review(reviewerName: "User", rating: 3, comments: "It's ok")]),
    Location(name: "North Grounds Gym", coordinate: CLLocationCoordinate2D(latitude: 38.05089159, longitude: -78.51285033), category: "Athletics", reviews: [Review(reviewerName: "User", rating: 3, comments: "It's ok")]),
    Location(name: "Clemons Library", coordinate: CLLocationCoordinate2D(latitude: 38.03634751, longitude: -78.50589651), category: "Study Spots", reviews: [Review(reviewerName: "User", rating: 3, comments: "It's ok")]),
    Location(name: "Alderman Library", coordinate: CLLocationCoordinate2D(latitude: 38.03650504, longitude: -78.50517647), category: "Study Spots", reviews: [Review(reviewerName: "User", rating: 3, comments: "It's ok")]),
    Location(name: "Clark Library", coordinate: CLLocationCoordinate2D(latitude: 38.03297804, longitude: -78.50789759), category: "Study Spots", reviews: [Review(reviewerName: "User", rating: 3, comments: "It's ok")]),
    Location(name: "Scott Stadium", coordinate: CLLocationCoordinate2D(latitude: 38.03118399, longitude: -78.51371396), category: "Athletics", reviews: [Review(reviewerName: "User", rating: 3, comments: "It's ok")]),
    Location(name: "John Paul Jones Arena", coordinate: CLLocationCoordinate2D(latitude: 38.04611688, longitude: -78.50675089), category: "Athletics", reviews: [Review(reviewerName: "User", rating: 3, comments: "It's ok")]),
    Location(name: "Klockner Stadium", coordinate: CLLocationCoordinate2D(latitude: 38.04693282, longitude: -78.51275726), category: "Athletics", reviews: [Review(reviewerName: "User", rating: 3, comments: "It's ok")]),
    Location(name: "Davenport Field", coordinate: CLLocationCoordinate2D(latitude: 38.04591585, longitude: -78.51338793), category: "Athletics", reviews: [Review(reviewerName: "User", rating: 3, comments: "It's ok")]),
    Location(name: "Lannigan Field", coordinate: CLLocationCoordinate2D(latitude: 38.04508807, longitude: -78.51191637), category: "Athletics", reviews: [Review(reviewerName: "User", rating: 3, comments: "It's ok")]),
    Location(name: "The Park", coordinate: CLLocationCoordinate2D(latitude: 38.05303433, longitude: -78.50473876), category: "Athletics", reviews: [Review(reviewerName: "User", rating: 3, comments: "It's ok")]),
]
