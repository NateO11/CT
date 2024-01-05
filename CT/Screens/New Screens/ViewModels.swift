//
//  ViewModels.swift
//  CT
//
//  Created by Griffin Harrison on 12/30/23.
//

import Foundation
import SwiftUI
import MapKit
import FirebaseFirestore
import CoreLocation

class ExploreViewModel: ObservableObject {
    @Published var colleges: [College] = []

    private var db = Firestore.firestore()
    

    func fetchColleges() {
        db.collection("Schools").addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("No documents in 'Schools'")
                return
            }

            self.colleges = documents.map { queryDocumentSnapshot -> College in
                let data = queryDocumentSnapshot.data()
                let id = queryDocumentSnapshot.documentID
                let name = data["name"] as? String ?? ""
                let city = data["city"] as? String ?? ""
                let description = data["description"] as? String ?? ""
                let image = data["image"] as? String ?? ""

                return College(id: id, name: name, city: city, description: description, image: image)
            }
        }
    }
}

class CollegeDetailViewModel: ObservableObject {
    @Published var college: College
    @Published var locations: [Location] = []

    private var db = Firestore.firestore()

    init(college: College) {
        self.college = college
    }
    
    func convertGeoPointToCoordinate(_ geoPoint: GeoPoint) -> CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: geoPoint.latitude, longitude: geoPoint.longitude)
    }

    func fetchLocations() {
        db.collection("Schools").document(college.id).collection("Locations").addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("No locations found for college \(self.college.name)")
                return
            }

            self.locations = documents.compactMap { queryDocumentSnapshot -> Location? in
                let data = queryDocumentSnapshot.data()
                let id = queryDocumentSnapshot.documentID
                let name = data["name"] as? String ?? ""
                let description = data["description"] as? String ?? ""
                let category = data["category"] as? String ?? ""

                // Parse the GeoPoint
                guard let geoPoint = data["coordinate"] as? GeoPoint else {
                    print("Invalid or missing coordinate for location \(name)")
                    return nil
                }
                
                let coordinate = self.convertGeoPointToCoordinate(geoPoint)

                return Location(id: id, name: name, description: description, coordinate: coordinate, category: category)
            }
        }
    }
}

class LocationViewModel: ObservableObject {
    @Published var reviews: [Review] = []
    @Published var college: College

    private var db = Firestore.firestore()
    
    init(college: College) {
        self.college = college
    }

    func fetchReviews(forLocation locationID: String) {
        db.collection("Schools").document(college.id).collection("Locations").document(locationID).collection("reviews").order(by: "timestamp", descending: true).addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("No reviews found for location")
                return
            }

            self.reviews = documents.map { doc -> Review in
                let data = doc.data()
                let id = doc.documentID
                let userID = data["userID"] as? String ?? ""
                let rating = data["rating"] as? Int ?? 0
                let text = data["text"] as? String ?? ""
                let timestamp = (data["timestamp"] as? Timestamp)?.dateValue() ?? Date()

                return Review(id: id, userID: userID, rating: rating, text: text, timestamp: timestamp)
            }
        }
    }

    func submitReview(rating: Int, text: String, forLocation locationID: String) {
        let reviewData: [String: Any] = [
            "userID": "currentUserID", // Replace with actual user ID
            "rating": rating,
            "text": text,
            "timestamp": Timestamp(date: Date())
        ]

        db.collection("Schools").document(college.id).collection("Locations").document(locationID).collection("reviews").addDocument(data: reviewData) { error in
            if let error = error {
                print("Error adding review: \(error.localizedDescription)")
            } else {
                print("Review successfully added!")
            }
        }
    }
}


class MapViewModel: ObservableObject {
    @Published var locations: [Location] = []
    @Published var filteredLocations: [Location] = []
    @Published var mapSelectionName: String?
    @Published var college: College

    private var db = Firestore.firestore()
    
    init(college: College) {
        self.college = college
    }
    
    func convertGeoPointToCoordinate(_ geoPoint: GeoPoint) -> CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: geoPoint.latitude, longitude: geoPoint.longitude)
    }


    // Call this method to fetch locations
    func fetchLocations() {
        print(college.name)
        db.collection("Schools").document(college.name).collection("Locations")
          .addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("No locations found for college \(self.college.name): \(error?.localizedDescription ?? "")")
                return
            }

            self.locations = documents.compactMap { doc -> Location? in
                // Parse the document into a Location object
                let data = doc.data()
                let id = data["id"] as? String ?? ""
                let name = data["name"] as? String ?? ""
                let description = data["description"] as? String ?? ""
                let category = data["category"] as? String ?? ""

                // Parse the GeoPoint
                guard let geoPoint = data["coordinate"] as? GeoPoint else {
                    print("Invalid or missing coordinate for location \(name)")
                    return nil // Return nil if GeoPoint is invalid
                }
                
                let coordinate = self.convertGeoPointToCoordinate(geoPoint)

                // Return a Location object or nil
                return Location(id: id, name: name, description: description, coordinate: coordinate, category: category)
            }
            print("Fetched locations: \(self.locations)")

            self.filteredLocations = self.locations
        }
    }


    // Call this method to update filtered locations based on a category
    func updateFilteredLocations(forCategory category: String) {
        if category == "All" {
            filteredLocations = locations
        } else {
            filteredLocations = locations.filter { $0.category == category }
        }
    }
}
