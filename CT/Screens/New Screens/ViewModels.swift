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


// view model used for the explore page, really the only thing this uses is an array of colleges pulled from firestore ... down the line this should further classify colleges so there can be multiple unique scroll views ... maybe a Virginia specific array or an out of state array ... could eventually integrate some sorting algorithm to produce X relevant colleges based on onboarding survey or other user preferences
class ExploreViewModel: ObservableObject {
    @Published var colleges: [College] = []
    // published is super useful ... whenever a published object is changed, all views using the object are updated to reflect those changes
    
    private var db = Firestore.firestore()
    // calls database from firebase, built on keys that are in various dependencies within the app

    func fetchColleges() {
        db.collection("Schools").addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("No documents in 'Schools'")
                return
            }
            // using guard let allows us to ensure everything checks out before we try and execute any further code

            self.colleges = documents.map { queryDocumentSnapshot -> College in
                let data = queryDocumentSnapshot.data()
                let id = queryDocumentSnapshot.documentID
                let available = data["available"] as? Bool ?? false
                let name = data["name"] as? String ?? ""
                let city = data["city"] as? String ?? ""
                let description = data["description"] as? String ?? ""
                let image = data["image"] as? String ?? ""
                
                // parses data from every college within the firestore database, uses nil coalescing to ensure no errors occur if data is absent

                return College(id: id, available: available, name: name, city: city, description: description, image: image)
                // this systematically fills the colleges array, which is ultimately displayed on the explore page and subsequently accessed when looking at school specific views
            }
        }
    }
}








class LocationInitialViewModel: ObservableObject {
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








class ForumViewModel: ObservableObject {
    @Published var reviews: [(user: String, time: Date, reviewTitle: String, review: String, rating: Int)] = []

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }

    func fetchReviews(forCollege collegeName: String, forumName: String) {
        let db = Firestore.firestore()

        let schoolsRef = db.collection("Schools")
        let collegeQuery = schoolsRef.whereField("name", isEqualTo: collegeName)

        collegeQuery.getDocuments { [weak self] (querySnapshot, error) in
            guard let self = self, error == nil else {
                print("Error fetching college: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            guard let document = querySnapshot?.documents.first else {
                print("College not found")
                return
            }

            let categoriesRef = document.reference.collection("categories")
            let forumDocumentRef = categoriesRef.document(forumName)
            let reviewsCollectionRef = forumDocumentRef.collection("Reviews")

            reviewsCollectionRef.getDocuments { (reviewsSnapshot, reviewsError) in
                guard reviewsError == nil else {
                    print("Error fetching reviews: \(reviewsError!.localizedDescription)")
                    return
                }

                guard let reviewsDocuments = reviewsSnapshot?.documents else {
                    print("No reviews found for the forum")
                    return
                }

                self.reviews = reviewsDocuments.compactMap { reviewDocument in
                    if let user = reviewDocument["User"] as? String,
                       let time = reviewDocument["Time"] as? Timestamp,
                       let rating = reviewDocument["Rating"] as? Int,
                       let reviewTitle = reviewDocument["ReviewTitle"] as? String,
                       let review = reviewDocument["Review"] as? String {
                        return (user: user, time: time.dateValue(), reviewTitle: reviewTitle, review: review, rating: rating)
                    }
                    return nil
                }

                DispatchQueue.main.async {
                    // Handle the fetched reviews as needed
                    print("Fetched reviews: \(self.reviews)")
                }
            }
        }
    }
}







class LocationExpandedViewModel: ObservableObject {
    @Published var reviews: [LocationReview] = []
    @Published var college: College
    @Published var location: Location
    @EnvironmentObject var authState: AuthState
    private var db = Firestore.firestore()

    
    init(college: College, location: Location) {
        self.college = college
        self.location = location
    }

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }

    func submitReview(rating: Int, title: String, text: String, forLocation locationID: String) {
        let reviewData: [String: Any] = [
            "userID": "currentUserID",
            "rating": rating,
            "title": title,
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
        db.collection("Users").document("OK").collection("reviews").addDocument(data: reviewData) { error in
            if let error = error {
                print("Error adding review: \(error.localizedDescription)")
            } else {
                print("Review successfully added!")
            }
        }
        
    }
    
    func fetchReviewsForLocation(collegeName: String, locationName: String) {
        let db = Firestore.firestore()
        let schoolsRef = db.collection("Schools")

        let collegeQuery = schoolsRef.whereField("name", isEqualTo: collegeName)

        collegeQuery.getDocuments { [weak self] (collegeQuerySnapshot, collegeError) in
            guard let self = self, collegeError == nil else {
                print("Error fetching college: \(collegeError?.localizedDescription ?? "Unknown error")")
                return
            }

            guard let collegeDocument = collegeQuerySnapshot?.documents.first else {
                print("College not found")
                return
            }

            let locationsRef = collegeDocument.reference.collection("Locations")
            let locationQuery = locationsRef.document(locationName)

            locationQuery.getDocument { (locationDocument, locationError) in
                guard locationError == nil else {
                    print("Error fetching location: \(locationError!.localizedDescription)")
                    return
                }

                guard let locationDocument = locationDocument else {
                    print("Location not found")
                    return
                }

                // Query for the reviews subcollection within the location
                let reviewsRef = locationDocument.reference.collection("reviews")

                reviewsRef.getDocuments { (reviewsQuerySnapshot, reviewsError) in
                    guard reviewsError == nil else {
                        print("Error fetching reviews: \(reviewsError!.localizedDescription)")
                        return
                    }

                    self.reviews = reviewsQuerySnapshot?.documents.compactMap { reviewDocument in
                        guard let text = reviewDocument["text"] as? String,
                              let rating = reviewDocument["rating"] as? Int,
                              let userID = reviewDocument["userID"] as? String,
                              let title = reviewDocument["title"] as? String,
                              let timestamp = reviewDocument["timestamp"] as? Timestamp else {
                            return nil
                        }

                        return LocationReview(text: text, rating: rating, userID: userID, title: title, timestamp: timestamp.dateValue())
                    } ?? []

                    DispatchQueue.main.async {
                        // Handle the fetched reviews as needed
                        print("Fetched reviews: \(self.reviews)")
                    }
                }
            }
        }
    }
}
