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

    @MainActor
    func fetchColleges() {
        db.collection("Schools").order(by: "rank").addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("No documents in 'Schools'")
                return
            }
            // using guard let allows us to ensure everything checks out before we try and execute any further code

            self.colleges = documents.map { queryDocumentSnapshot -> College in
                let data = queryDocumentSnapshot.data()
                let id = queryDocumentSnapshot.documentID
                let available = data["available"] as? Bool ?? true
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





// view model used for all views associated with a specific location - the initial view, the expanded view, and the review writing view... by passing information through a single view model its easier to ensure all location data is consistent
class LocationViewModel: ObservableObject {
    @Published var reviews: [Review] = []
    @Published var college: College
    @Published var location: Location
    // establishing the specific location and associated college, and preparing to fetch reviews if needed
    
    var authState: AuthViewModel?
    // looking to implement authstate so we can pass through reviews associated with a specific user, but haven't quite gotten there yet
    
    private var db = Firestore.firestore()

    
    init(college: College, location: Location, authState: AuthViewModel? = nil) {
        self.college = college
        self.location = location
        self.authState = authState
    }
    // initiating any screen requires passing through the college and location

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }
    // function to format date when ultimately displaying reviews

    @MainActor 
    func submitReview(rating: Int, title: String, text: String, forLocation locationID: String) {
        let reviewData: [String: Any] = [
            "school": college.name,
            "location": location.name,
            "userID": authState?.currentUser?.id ?? "defaultID",
            "rating": rating,
            "title": title,
            "text": text,
            "timestamp": Timestamp(date: Date())
        ] // takes review data and timestamp and turns it into a single element

        db.collection("Schools").document(college.id).collection("Locations").document(locationID).collection("reviews").addDocument(data: reviewData) { error in
            if let error = error {
                print("Error adding review: \(error.localizedDescription)")
            } else {
                print("Review successfully added!")
            }
        } // sends the new review element to a reviews collection for that specific location ... need to work on this logic to ensure it goes to the location Id and not the location name
        db.collection("Users").document(authState?.currentUser?.id ?? "test").collection("reviews").addDocument(data: reviewData) { error in
            if let error = error {
                print("Error adding review: \(error.localizedDescription)")
            } else {
                print("Review successfully added!")
            }
        } // attempt at sending the new review element to a reviews collection for the current user ... wasn't working due to authstate/firestore complications but this is a very achieveable step
    }
    
    // function to fetch reviews for the selected location, which will eventually be displayed on the location expanded review page
    func fetchReviewsForLocation(collegeName: String, locationName: String) {
        let db = Firestore.firestore()
        let schoolsRef = db.collection("Schools")
        let collegeQuery = schoolsRef.whereField("name", isEqualTo: collegeName)
        // setting up the query for that specific college
        
        collegeQuery.getDocuments { [weak self] (collegeQuerySnapshot, collegeError) in
            guard let self = self, collegeError == nil else {
                print("Error fetching college: \(collegeError?.localizedDescription ?? "Unknown error")")
                return
            }

            guard let collegeDocument = collegeQuerySnapshot?.documents.first else {
                print("College not found")
                return
            } // error handling if the college doesn't exist for whatever reason

            let locationsRef = collegeDocument.reference.collection("Locations")
            let locationQuery = locationsRef.document(locationName)
            // setting up the query for that specific location
            
            locationQuery.getDocument { (locationDocument, locationError) in
                guard locationError == nil else {
                    print("Error fetching location: \(locationError!.localizedDescription)")
                    return
                }

                guard let locationDocument = locationDocument else {
                    print("Location not found")
                    return
                } // error handling if the location doesn't exist for whatever reason

                // query for the reviews subcollection within the location
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

                        return Review(text: text, rating: rating, userID: userID, title: title, timestamp: timestamp.dateValue())
                    } ?? []
                    // returns series of reviews, or a blank array if no reviews have been written yet (which would ultimately display an alternative message on the location expanded page) ... at this point we would implement some sort of filtering / relevancy algorithm if we wanted to show X amount of reviews rather than every single one
                    

                    DispatchQueue.main.async {
                        // I dont totally understand the underlying logic here, but this essentially ensures the function is executed on the main thread and data is loaded at the proper time
                        print("Fetched reviews: \(self.reviews)")
                    }
                }
            }
        }
    }
}



// view model used to generate the map screen for each school... includes functions for fetching locations, interpreting firestore data, and filtering location categories ... might modify this in the future so we could have an overall map screen that shows individual schools as icons instead of specific locations, but that might require an entirely new view model instead
class MapViewModel: ObservableObject {
    @Published var locations: [Location] = []
    @Published var filteredLocations: [Location] = []
    // establishes blank array for locations and filtered locations, which will be updated when the map appears and is filtered respectively
    
    @Published var mapSelectionName: String?
    // the selection applies to the icon currently selected on the map ... this value is optional because it starts as nil (no object selected) and deselects whenever a location is closed
    
    @Published var college: College
    // "published" allows the map and subsequent views to constantly update when changes are made to the data being pulled

    private var db = Firestore.firestore()
    
    init(college: College) {
        self.college = college
    }
    
    func convertGeoPointToCoordinate(_ geoPoint: GeoPoint) -> CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: geoPoint.latitude, longitude: geoPoint.longitude)
    }
    // minor function that pulls firestore data (geopoint) and converts it into the type of object needed for map interpretation (CLLcoords)

    func fetchLocations() {
        print(college.name)
        db.collection("Schools").document(college.name).collection("Locations")
          .addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("No locations found for college \(self.college.name): \(error?.localizedDescription ?? "")")
                return
                // built in print statements to verify that fetching pathways are operating correctly
            }

            self.locations = documents.compactMap { doc -> Location? in
                // parse the document into a Location object
                let data = doc.data()
                let id = data["id"] as? String ?? ""
                let name = data["name"] as? String ?? ""
                let description = data["description"] as? String ?? ""
                let category = data["category"] as? String ?? ""

                // parse the GeoPoint
                guard let geoPoint = data["coordinate"] as? GeoPoint else {
                    print("Invalid or missing coordinate for location \(name)")
                    return nil // Return nil if GeoPoint is invalid
                }
                
                let coordinate = self.convertGeoPointToCoordinate(geoPoint)
                // convert the coordinate into the proper format for display on map

                // return a Location object or nil
                return Location(id: id, name: name, description: description, coordinate: coordinate, category: category)
            }
            print("Fetched locations: \(self.locations)")

            self.filteredLocations = self.locations
            // sets filtered locations to be all locations as an unfiltered default
        }
    }

    // function to update filtered locations and map when a new category is selected
    func updateFilteredLocations(forCategory category: String) {
        if category == "All" {
            filteredLocations = locations
        } else {
            filteredLocations = locations.filter { $0.category == category }
        }
    }
}




// view model for the forums page... basically the same functionality as the location reviews pages but the ability to write reviews is not fully built out yet ... includes date formatting and firestore fetching
class ForumViewModel: ObservableObject {
    @Published var reviews: [Review] = []
    @Published var college: College
    @Published var forum: String
    // blank array of reviews that gets filled up and updated after fetching
    
    init(college: College, forum: String) {
        self.college = college
        self.forum = forum
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }
    // like usual, function to convert the embedded firestore date data into something more readable

    func fetchReviews(forCollege college: College, forumName: String) {
        let db = Firestore.firestore()
        
        let schoolsRef = db.collection("Schools")
        let collegeQuery = schoolsRef.whereField("name", isEqualTo: college.name)
        // ensuring query is only applicable to the specific school
        collegeQuery.getDocuments { [weak self] (querySnapshot, error) in
            guard let self = self, error == nil else {
                print("Error fetching college: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            // error handling if the database cannot find the college for whatever reason
            
            guard let document = querySnapshot?.documents.first else {
                print("College not found")
                return
            }

            let reviewsCollectionRef = document.reference.collection("categories").document(forumName).collection("Reviews")
            // mapping the correct document path in order to fetch the relevant reviews
            
            reviewsCollectionRef.getDocuments { (reviewsSnapshot, reviewsError) in
                guard reviewsError == nil else {
                    print("Error fetching reviews: \(reviewsError!.localizedDescription)")
                    return
                }

                guard let reviewsDocuments = reviewsSnapshot?.documents else {
                    print("No reviews found for the forum")
                    return
                }
                
                // maps the data to a review and returns it for display
                self.reviews = reviewsDocuments.compactMap { reviewDocument in
                    guard let userID = reviewDocument["userID"] as? String,
                       let timestamp = reviewDocument["timestamp"] as? Timestamp,
                       let rating = reviewDocument["rating"] as? Int,
                       let title = reviewDocument["title"] as? String,
                       let text = reviewDocument["text"] as? String else {
                        return nil
                    }
                    return Review(text: text, rating: rating, userID: userID, title: title, timestamp: timestamp.dateValue())
                }

                DispatchQueue.main.async {
                    print("Fetched reviews: \(self.reviews)")
                    // debugging statement to ensure reviews are properly fetched 
                }
            }
        }
    }
}





