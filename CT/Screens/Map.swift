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

struct FirestoreLocation: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var coordinate: GeoPoint
    var category: String
    var reviews: [FirestoreReview]
}

struct FirestoreReview: Identifiable, Codable {
    @DocumentID var id: String?
    var reviewerName: String
    var rating: Int
    var comments: String
}

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
                    ForEach(firestoreLocations, id: \.name) {firestoreLocation in
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
                        .overlay {
                            VStack {
                                Spacer()
                                Button(action: {
                                    showReviews.toggle()
                                }) {
                                    Text("Add Review")
                                        .padding()
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
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
    var filteredLocations: [Location] {
        // Filter locations based on the selected category
        if selectedCategory == "All" {
            return locations
        } else {
            return locations.filter { $0.category == selectedCategory }
        }
    }
}

extension MapView {
    func fetchMapDataFromFirestore() async {
        let db = Firestore.firestore()

        do {
            let querySnapshot = try await db.collection("Schools").document("UVA").collection("uvaLocations").getDocuments()

            self.firestoreLocations = try querySnapshot.documents.compactMap {
                let firestoreLocation = try $0.data(as: FirestoreLocation.self)
                return firestoreLocation
            }
        } catch {
            print("Error getting documents: \(error)")
        }
    }
}


extension MapView {
    func addReview(firestoreLocation: FirestoreLocation, review: FirestoreReview) {
        guard let index = firestoreLocations.firstIndex(where: { $0.id == firestoreLocation.id }) else {
            return
        }

        firestoreLocations[index].reviews.append(review)
        // Update the reviews in Firebase here
    }
}


#Preview {
    MapView()
}
