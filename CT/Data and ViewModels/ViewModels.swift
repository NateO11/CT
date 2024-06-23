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

    
    func convertGeoPointToCoordinate(_ geoPoint: GeoPoint) -> CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: geoPoint.latitude, longitude: geoPoint.longitude)
    }
    
    func searchColleges(with query: String) -> [College] {
        return colleges.filter { college in
            college.name.localizedCaseInsensitiveContains(query)
        }
    }

    
    @MainActor
    func fetchColleges() {
        db.collection("Schools").order(by: "rank")
            .addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("No documents in 'Schools'")
                return
            }
            // using guard let allows us to ensure everything checks out before we try and execute any further code

            self.colleges = documents.map { doc -> College in
                let data = doc.data()
                let id = doc.documentID
                let available = data["available"] as? Bool ?? true
                let name = data["name"] as? String ?? ""
                let city = data["city"] as? String ?? ""
                let description = data["description"] as? String ?? ""
                let image = data["image"] as? String ?? ""
                
                let geoPoint = data["coords"] as? GeoPoint ?? GeoPoint(latitude: 38, longitude: 77)
                
                let coordinate = self.convertGeoPointToCoordinate(geoPoint)
                let color = data["color"] as? Int ?? 0
                
                
                
                // parses data from every college within the firestore database, uses nil coalescing to ensure no errors occur if data is absent

                return College(id: id, available: available, name: name, city: city, description: description, image: image, coordinate: coordinate, color: Color(hex: color))
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
        fetchReviewsForLocation2()
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
            "schoolName": college.name,
            "locationName": location.name,
            "userID": authState?.currentUser?.id ?? "defaultID",
            "userName" : authState?.currentUser?.fullname ?? "defaultName",
            "userInitials" : authState?.currentUser?.intitals ?? "defaultInitials",
            "rating": rating,
            "title": title,
            "text": text,
            "timestamp": Timestamp(date: Date())
        ] // takes review data and timestamp and turns it into a single element

        db.collection("Schools").document(college.id).collection("NewLocations").document(locationID).collection("reviews").addDocument(data: reviewData) { error in
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
    
    func fetchReviewsForLocation2() {
            let reviewsRef = db.collection("Schools").document(college.id)
                                    .collection("NewLocations").document(location.id)
                                    .collection("reviews")
            
            reviewsRef.getDocuments { [weak self] snapshot, error in
                guard let self = self else { return }
                if let error = error {
                    print("Error fetching reviews: \(error.localizedDescription)")
                    return
                }
                
                self.reviews = snapshot?.documents.compactMap { document in
                    try? document.data(as: Review.self)
                } ?? []
                
                DispatchQueue.main.async {
                    self.objectWillChange.send()
                }
            }
        }
    
    
}


class TopicViewModel: ObservableObject {
    @Published var stats: [Stat] = []
    @Published var reviews: [Review] = []
    @Published var bodyText: String = ""
    
    var authState: AuthViewModel?
    @Published var topic: String
    @Published var college: College
    private var db = Firestore.firestore()
    init(topic: String, college: College, authState: AuthViewModel? = nil) {
        self.topic = topic
        self.college = college
        self.authState = authState
    }
    
    func fetchReviews() {
        let reviewsRef = db.collection("Schools").document(college.id).collection("Topics").document(topic).collection("reviews")
        
        reviewsRef.addSnapshotListener { [weak self] snapshot, error in
            guard let self = self else { return }
            if let error = error {
                print("Error fetching reviews: \(error.localizedDescription)")
                return
            }
            
            self.reviews = snapshot?.documents.compactMap { document in
                try? document.data(as: Review.self)
            } ?? []
            
            DispatchQueue.main.async {
                self.objectWillChange.send()
            }
        }
    }

    func fetchTopicData() {
        let topicRef = db.collection("Schools").document(college.id).collection("Topics").document(topic)
        topicRef.getDocument { [weak self] document, error in
            guard let self = self else { return }
            if let error = error {
                print("Error fetching topic data: \(error.localizedDescription)")
                return
            }
            
            if let document = document, document.exists {
                self.bodyText = document.get("bodyText") as? String ?? ""
                
                let statsRef = topicRef.collection("stats")
                statsRef.getDocuments { statsSnapshot, error in
                    if let error = error {
                        print("Error fetching stats: \(error.localizedDescription)")
                        return
                    }
                    
                    self.stats = statsSnapshot?.documents.compactMap { document in
                        try? document.data(as: Stat.self)
                    } ?? []
                    
                    DispatchQueue.main.async {
                        self.objectWillChange.send()
                    }
                }
            } else {
                print("Topic document does not exist")
            }
        }
    
    }
    
    @MainActor
    func submitReview(rating: Int, title: String, text: String, forLocation locationID: String) {
        let reviewData: [String: Any] = [
            "schoolName": college.name,
            "locationName": topic,
            "userID": authState?.currentUser?.id ?? "defaultID",
            "userName" : authState?.currentUser?.fullname ?? "defaultName",
            "userInitials" : authState?.currentUser?.intitals ?? "defaultInitials",
            "rating": rating,
            "title": title,
            "text": text,
            "timestamp": Timestamp(date: Date())
        ] // takes review data and timestamp and turns it into a single element

        db.collection("Schools").document(college.id).collection("Topics").document(topic).collection("reviews").addDocument(data: reviewData) { error in
            if let error = error {
                print("Error adding review: \(error.localizedDescription)")
            } else {
                print("Review successfully added!")
                self.fetchReviews()
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
}

// view model used to generate the map screen for each school... includes functions for fetching locations, interpreting firestore data, and filtering location categories ... might modify this in the future so we could have an overall map screen that shows individual schools as icons instead of specific locations, but that might require an entirely new view model instead
class MapViewModel: ObservableObject {
    @Published var locations: [Location] = []
    @Published var info: [SchoolInfo] = []
    @Published var infoAcademic: [SchoolInfo] = []
    @Published var infoSocial: [SchoolInfo] = []
    @Published var infoOther: [SchoolInfo] = []
    @Published var filteredLocations: [Location] = []
    @Published var featuredLocations: [Location] = []
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
        print("Fetching locations for \(college.name)")
        db.collection("Schools").document(college.name).collection("NewLocations")
          .addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("No locations found for college \(self.college.name): \(error?.localizedDescription ?? "")")
                return
                // built in print statements to verify that fetching pathways are operating correctly
            }

            self.locations = documents.compactMap { doc -> Location? in
                // parse the document into a Location object
                let data = doc.data()
                let id = doc.documentID
                // let id = data["id"] as? String ?? ""
                let name = data["name"] as? String ?? ""
                let description = data["description"] as? String ?? ""
                let category = data["category"] as? String ?? ""
                let imageLink = data["imageURL"] as? String ?? ""
                let featured = data["featured"] as? Bool ?? false

                // parse the GeoPoint
                guard let geoPoint = data["coordinate"] as? GeoPoint else {
                    print("Invalid or missing coordinate for location \(name)")
                    return nil // Return nil if GeoPoint is invalid
                }
                
                let coordinate = self.convertGeoPointToCoordinate(geoPoint)
                // convert the coordinate into the proper format for display on map

                // return a Location object or nil
                return Location(id: id, name: name, description: description, coordinate: coordinate, category: category, imageLink: imageLink, featured: featured)
            }
              print("Fetched locations: \(self.locations.count)")

              self.filteredLocations = self.locations
              self.featuredLocations = self.locations.filter { $0.featured == true }
              
            // sets filtered locations to be all locations as an unfiltered default
        }
    }
    
    func fetchInfo(classification: String) {
        
        print("Fetching \(classification) info for \(college.name)")
        db.collection("Schools").document(college.name).collection("Info")
          .whereField("classification", isEqualTo: classification)
          .addSnapshotListener { querySnapshot, error in
              guard let documents = querySnapshot?.documents else {
                  print("No info found for college \(self.college.name): \(error?.localizedDescription ?? "")")
                  return
                  // built in print statements to verify that fetching pathways are operating correctly
              }
              
              let fetchedInfo = documents.compactMap { doc -> SchoolInfo? in
                  // parse the document into a Location object
                  let data = doc.data()
                  let category = data["category"] as? String ?? ""
                  let classification = data["classification"] as? String ?? ""
                  let description = data["description"] as? String ?? ""
                  let stats = data["stats"] as? [Int] ?? []
                  let statDescriptions = data["statDescriptions"] as? [String] ?? []
                  let locations = data["locations"] as? [String] ?? []
                  
                  // return an info object or nil
                  return SchoolInfo(category: category, stats: stats, classification: classification, statDescriptions: statDescriptions, description: description, locations: locations)
              }
              switch classification {
              case "Academic":
                  self.infoAcademic = fetchedInfo
                  print("Fetched Academic Info: \(self.infoAcademic.count)")
              case "Social":
                  self.infoSocial = fetchedInfo
                  print("Fetched Social Info: \(self.infoSocial.count)")
              case "Other":
                  self.infoOther = fetchedInfo
                  print("Fetched Other Info: \(self.infoOther.count)")
              default:
                  self.info = fetchedInfo
                  print("Fetched All Info: \(self.info.count)")
              }
          

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
    
    func searchLocations(with query: String)  {
        if query == "" {
            filteredLocations = locations
        } else {
            filteredLocations = locations.filter{ location in
                location.name.localizedCaseInsensitiveContains(query)
            }
        }
        
    }
    
}




// view model for the forums page... basically the same functionality as the location reviews pages but the ability to write reviews is not fully built out yet ... includes date formatting and firestore fetching
class ForumViewModel: ObservableObject {
    @Published var reviews: [Review] = []
    @Published var college: College
    @Published var info: SchoolInfo
    // establishing the specific location and associated college, and preparing to fetch reviews if needed
    
    var authState: AuthViewModel?
    // looking to implement authstate so we can pass through reviews associated with a specific user, but haven't quite gotten there yet
    
    private var db = Firestore.firestore()

    
    init(college: College, info: SchoolInfo, authState: AuthViewModel? = nil) {
        self.college = college
        self.info = info
        self.authState = authState
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }
    // function to format date when ultimately displaying reviews

    @MainActor
    func submitReview(rating: Int, title: String, text: String, forInfo infoID: String) {
        let reviewData: [String: Any] = [
            "schoolName": college.name,
            "locationName": info.category,
            "userID": authState?.currentUser?.id ?? "defaultID",
            "userName": authState?.currentUser?.fullname ?? "defaultName",
            "userInitials": authState?.currentUser?.intitals ?? "defaultInitials",
            "rating": rating,
            "title": title,
            "text": text,
            "timestamp": Timestamp(date: Date())
        ] // takes review data and timestamp and turns it into a single element

        db.collection("Schools").document(college.id).collection("Info").document(infoID).collection("reviews").addDocument(data: reviewData) { error in
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
    func fetchReviewsForInfo(collegeName: String, infoName: String) {
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

            let locationsRef = collegeDocument.reference.collection("Info")
            let locationQuery = locationsRef.document(infoName)
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
                              let userName = reviewDocument["userName"] as? String,
                              let userInitials = reviewDocument["userInitials"] as? String,
                              let title = reviewDocument["title"] as? String,
                              let timestamp = reviewDocument["timestamp"] as? Timestamp,
                              let locationName = reviewDocument["locationName"] as? String,
                              let schoolName = reviewDocument["schoolName"] as? String
                        else {
                            return nil
                        }

                        return Review(text: text, rating: rating, userID: userID, userName: userName, userInitials: userInitials, title: title, timestamp: timestamp.dateValue(), locationName: locationName, schoolName: schoolName)
                    } ?? []
                    // returns series of reviews, or a blank array if no reviews have been written yet (which would ultimately display an alternative message on the location expanded page) ... at this point we would implement some sort of filtering / relevancy algorithm if we wanted to show X amount of reviews rather than every single one
                    

                    DispatchQueue.main.async {
                        // I dont totally understand the underlying logic here, but this essentially ensures the function is executed on the main thread and data is loaded at the proper time
                        print("Fetched reviews for \(infoName): \(self.reviews)")
                    }
                }
            }
        }
    }
}


class Bookmarks: ObservableObject {
    // the actual resorts the user has favorited
    @Published private var bookmarks: Set<String>

    // the key we're using to read/write in UserDefaults
    private let key = "Favorites"

    init() {
        // load our saved data

        // still here? Use an empty array
        bookmarks = []
    }

    // returns true if our set contains this resort
    func contains(_ location: Location) -> Bool {
        bookmarks.contains(location.id)
    }

    // adds the resort to our set and saves the change
    func add(_ location: Location) {
        bookmarks.insert(location.id)
        save()
    }

    // removes the resort from our set and saves the change
    func remove(_ location: Location) {
        bookmarks.remove(location.id)
        save()
    }

    func save() {
        // write out our data
    }
}
