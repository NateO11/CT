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

                return College(id: id, available: available, name: name, city: city, description: description, image: image, coordinate: coordinate, color: Color(hex: color), imageURLs: [:])
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
        fetchImageURLs()
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
    
    func fetchImageURLs() {
            db.collection("Schools").document(college.name).collection("ImageURLs").getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error fetching image URLs: \(error)")
                    return
                }
                var imageURLs: [String: String] = [:]
                for document in snapshot?.documents ?? [] {
                    let data = document.data()
                    if let topic = data["topic"] as? String, let url = data["url"] as? String {
                        imageURLs[topic] = url
                    }
                }
                self.college.imageURLs = imageURLs
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






struct BookmarkInfo: Hashable, Codable {
    var id: String
    var locationImageURL: String
    var name: String
    var schoolName: String
}

class Bookmarks: ObservableObject {
    // the actual resorts the user has favorited
    @Published private var bookmarks: Set<BookmarkInfo>

    // the key we're using to read/write in UserDefaults
    private let key = "Favorites"

    init() {
        // load our saved data
        if let savedData = UserDefaults.standard.data(forKey: key) {
                    if let decodedData = try? JSONDecoder().decode(Set<BookmarkInfo>.self, from: savedData) {
                        bookmarks = decodedData
                        return
                    }
                }
        // still here? Use an empty array
        bookmarks = []
    }

    // returns true if our set contains this resort
    func contains(_ location: Location) -> Bool {
        bookmarks.contains { $0.id == location.id}
    }

    // adds the resort to our set and saves the change
    func add(_ location: Location, for college: College) {
        let bookmark = BookmarkInfo(id: location.id, locationImageURL: location.imageLink, name: location.name, schoolName: college.id)
        bookmarks.insert(bookmark)
        save()
        bookmarks.forEach { bookmark in
            print(bookmark.schoolName)
            print(bookmark.name)
        }
    }

    // removes the resort from our set and saves the change
    func remove(_ location: Location, for college: College) {
        if let bookmark = bookmarks.first(where: { $0.id == location.id }) {
            bookmarks.remove(bookmark)
            save()
        }
    }

    func save() {
        if let encodedData = try? JSONEncoder().encode(bookmarks) {
            UserDefaults.standard.set(encodedData, forKey: key)
        }
    }
    
    func getBookmarks() -> [BookmarkInfo] {
        return Array(bookmarks)
    }
}
