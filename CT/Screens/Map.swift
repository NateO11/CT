//
//  Map.swift
//  CT
//
//  Created by Griffin Harrison on 12/26/23.
//

import SwiftUI
import MapKit
import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore
import FirebaseCore

struct FirestoreLocation: Identifiable {
    @DocumentID var id: String?
    var name: String
    var coordinate: GeoPoint
    var category: String
    var reviews: [FirestoreReview] = []

    enum CodingKeys: String, CodingKey {
        case id, name, coordinate, category
    }
}

extension FirestoreLocation: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        coordinate = try container.decode(GeoPoint.self, forKey: .coordinate)
        category = try container.decode(String.self, forKey: .category)
        // reviews is not decoded here
    }
}

struct FirestoreReview: Identifiable, Codable {
    @DocumentID var id: String?
    var reviewerName: String
    var rating: Int
    var comments: String
}

let defaultPosition = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 38.04272231323672, longitude: -78.50961596590895), span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.022)))


struct MapView: View {
    @State private var position = defaultPosition
    @State private var showCategorySelect = false
    @State private var selectedCategory = "All"
    @State private var mapSelectionName: String? = nil
    @State private var selectedLocation: FirestoreLocation? = nil
    @State private var showReviews: Bool = false
    @Namespace private var locationSpace
    @State private var firestoreLocations: [FirestoreLocation] = []
    
    var categorySelect: some View {
        CategorySelectView(selectedCategory: $selectedCategory, showCategorySelect: $showCategorySelect)
    }
    
    @ViewBuilder func reviewDisplay(firestoreLocation: FirestoreLocation?) -> some View {
            ReviewDisplayView(firestoreLocation: firestoreLocation)
        }


    var body: some View {
        NavigationStack() {
            VStack {
                Map(initialPosition: position, selection: $mapSelectionName) {
                    ForEach(filteredLocations, id: \.name) {firestoreLocation in
                        Marker(firestoreLocation.name, systemImage: symbolForCategory(firestoreLocation.category), coordinate: CLLocationCoordinate2D(latitude: firestoreLocation.coordinate.latitude, longitude: firestoreLocation.coordinate.longitude))
                            .tint(colorForCategory(firestoreLocation.category))
                    }
                }
                .onAppear {
                    Task {
                        await fetchMapDataFromFirestore()
                    }
                }
                .mapStyle(.standard(pointsOfInterest: []))
                .mapControls {
                    MapCompass()
                        .buttonBorderShape(.circle)
                        .padding()
                    MapUserLocationButton()
                        .buttonBorderShape(.circle)
                        .padding()
                }
                .overlay(alignment: .bottomTrailing) {
                    Button("") {
                        showCategorySelect.toggle()
                    }
                    .buttonStyle(CategoryButton(category: selectedCategory))
                    .padding(30)
                    .sheet(isPresented: $showCategorySelect) {
                        categorySelect
                            .presentationDetents([.fraction(0.25)])
                            .presentationDragIndicator(.visible)
                            .presentationCornerRadius(25)
                    }
                }
                .navigationTitle("University of Virginia - \(selectedCategory)")
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
                
                // Sheet for displaying reviews
                .sheet(item: $selectedLocation) { firestoreLocation in
                    reviewDisplay(firestoreLocation: firestoreLocation)
                        .presentationDetents([.fraction(0.5)])
                        .overlay {
                            VStack {
                                Spacer()
                                Button(action: {
                                    showReviews.toggle()
                                }) {
                                    Text("Add Review")
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(Color.black)
                                        .cornerRadius(8)
                                        .padding(.trailing, 20)
                                        .padding(.bottom, 20)
                                }
                                .padding()
                                .sheet(isPresented: $showReviews) {
                                    ReviewSubmissionForm(firestoreLocation: firestoreLocation) { newReview in
                                        // Handle the new review and update Firestore
                                        if let index = firestoreLocations.firstIndex(where: { $0.id == firestoreLocation.id }) {
                                            firestoreLocations[index].reviews.append(newReview)
                                            // Update the reviews in Firebase here
                                        }
                                        showReviews.toggle()
                                    }
                                }
                            }
                        }
                    }
                    
            }
            .onChange(of: mapSelectionName) { oldValue, newValue in
                if let selected = firestoreLocations.first(where: { $0.name == newValue }) {
                    selectedLocation = selected
                } else {
                    selectedLocation = nil
                }
        }
        }
    }
}

extension MapView {
    var filteredLocations: [FirestoreLocation] {
        // Filter locations based on the selected category
        if selectedCategory == "All" {
            return firestoreLocations
        } else {
            return firestoreLocations.filter { $0.category == selectedCategory }
        }
    }
}

extension MapView {
    func fetchMapDataFromFirestore() async {
        print("Starting to fetch data from Firestore...")

        let db = Firestore.firestore()
        let uvaDocumentRef = db.collection("Schools").document("UVA")
        let uvaLocationsCollectionRef = uvaDocumentRef.collection("uvaLocations")

        do {
            let querySnapshot = try await uvaLocationsCollectionRef.getDocuments()
            var locations: [FirestoreLocation] = []

            print("Fetched \(querySnapshot.documents.count) location documents. Yay")

            for document in querySnapshot.documents {
                do {
                    var location = try document.data(as: FirestoreLocation.self)
                    print("Processing location: \(location.name), Category: \(location.category)")

                    let reviewsCollectionRef = uvaLocationsCollectionRef.document(document.documentID).collection("reviews")
                    let reviewsSnapshot = try await reviewsCollectionRef.getDocuments()

                    location.reviews = reviewsSnapshot.documents.compactMap { reviewDoc in
                        let review = try? reviewDoc.data(as: FirestoreReview.self)
                        if let review = review {
                            print("Fetched review for \(location.name): ")
                            print("\(review.reviewerName): \(review.rating) stars - \(review.comments)")
                        }
                        return review
                    }

                    locations.append(location)
                } catch {
                    print("Error processing location document: \(error)")
                }
            }

            firestoreLocations = locations
            print("Finished fetching and processing Firestore data.")
            print()
        } catch {
            print("Error fetching locations from Firestore: \(error)")
        }
    }
}

extension MapView {
    func addReview(firestoreLocation: FirestoreLocation, review: FirestoreReview) {
        // Correctly reference the Firestore path
        let db = Firestore.firestore()
        let locationRef = db.collection("Schools").document("UVA")
                          .collection("uvaLocations").document(firestoreLocation.id ?? "")

        locationRef.collection("reviews").addDocument(data: [
            "reviewerName": review.reviewerName,
            "rating": review.rating,
            "comments": review.comments
        ]) { error in
            if let error = error {
                print("Error adding review: \(error)")
            } else {
                // Update local state
                if let index = firestoreLocations.firstIndex(where: { $0.id == firestoreLocation.id }) {
                    firestoreLocations[index].reviews.append(review)
                }
            }
        }
    }
}



#Preview {
    MapView()
}
